resource "aws_s3_bucket" "Atifact-Bucket" {
  bucket = var.S3_Bucket_Name

  tags = {
    Name        = "Atifact-Bucket"
    Environment = "Dev"
  }
}