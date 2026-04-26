module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "strata-eks-cluster"
  kubernetes_version = "1.30"              

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    strata_nodes = {
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
      min_size     = 1
      max_size     = 3
      desired_size = 2

      key_name = aws_key_pair.bastion_key.key_name

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "Strata-Ops"
  }
}