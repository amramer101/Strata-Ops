module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # 1. تحديث رقم الإصدار ليتوافق مع AWS Provider 6.x
  version = "~> 21.0"

  # 2. تعديل أسماء المتغيرات (Breaking Changes)
  name               = "strata-eks-cluster" # كانت cluster_name
  kubernetes_version = "1.30"               # كانت cluster_version

  endpoint_public_access = true # كانت cluster_endpoint_public_access 

  # 3. باقي الإعدادات زي ما هي بالظبط (مفيهاش تغيير)
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    strata_nodes = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      key_name = aws_key_pair.bastion_key.key_name
    }
  }

  tags = {
    Environment = "dev"
    Project     = "Strata-Ops"
  }
}