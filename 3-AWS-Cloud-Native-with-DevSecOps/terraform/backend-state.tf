terraform {
  backend "s3" {
    bucket = "s3-terraform-state-strata-ops-project"
    key    = "s3-terraform-state-strata-ops-project/terraform"
    region = "eu-central-1"
  }
}
