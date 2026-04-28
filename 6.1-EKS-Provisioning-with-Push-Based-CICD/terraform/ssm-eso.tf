# 1. IRSA: IAM Policy & Role 
data "aws_iam_policy_document" "eso_ssm_policy" {
  statement {
    actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = ["arn:aws:ssm:${var.AWS_Region}:${data.aws_caller_identity.current.account_id}:parameter/strata/*"]
  }
}

resource "aws_iam_policy" "eso_policy" {
  name   = "strata-eso-ssm-policy"
  policy = data.aws_iam_policy_document.eso_ssm_policy.json
}

module "eso_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "strata-eso-role"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:eso-service-account"]
    }
  }

  role_policy_arns = {
    eso_policy = aws_iam_policy.eso_policy.arn
  }
}

# -------------------------------------------------------------------------------------

# 2. ESO: Helm Release

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "kube-system"
  version    = "0.9.9"

  depends_on = [module.eks, helm_release.alb_controller]

  set = [
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "eso-service-account"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.eso_irsa_role.iam_role_arn
    }
  ]
}