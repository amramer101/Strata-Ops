resource "aws_ecr_repository" "Docker_tomcat" {
  name                 = "eks_dockertomcat_repo_staraops"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}