resource "aws_ecr_repository" "Docker-tomcat" {
  name                 = "Docker-tomcat"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}