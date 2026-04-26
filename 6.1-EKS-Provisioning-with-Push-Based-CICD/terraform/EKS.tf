module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "strata-eks-cluster"
  kubernetes_version = "1.30"              

  endpoint_public_access  = true
  endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)

  enable_cluster_creator_admin_permissions = true

  addons = {
    vpc-cni = {
      before_compute = true
    }
    kube-proxy = {
      before_compute = true
    }
    coredns = {
      before_compute = true
    }
  }

  # شلنا بلوك الـ additional_rules من هنا عشان نمنع الـ Duplicate

  eks_managed_node_groups = {
    strata_nodes = {
      instance_types = ["t3.medium"]
      ami_type       = "AL2023_x86_64_STANDARD"
      
      min_size     = 1
      max_size     = 3
      desired_size = 2
      subnet_ids   = module.vpc.public_subnets

      key_name = aws_key_pair.bastion_key.key_name
      use_custom_launch_template = false
      remote_access = {
        ec2_ssh_key               = aws_key_pair.bastion_key.key_name
        source_security_group_ids = [aws_security_group.Bastion-SG.id]
      }

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEKS_CNI_Policy         = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "Strata-Ops"
  }
  
  depends_on = [ aws_db_instance.RDS, aws_mq_broker.RabbitMQ, aws_elasticache_cluster.ElastiCache ]
}