module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.24"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cloudwatch_log_group_retention_in_days = 1

  eks_managed_node_group_defaults = {
    instance_types = ["m5.large"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}


