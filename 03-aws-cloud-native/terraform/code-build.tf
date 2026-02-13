# 1. S3 Bucket for Artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "eprofile-cicd-artifacts-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 2. CodeBuild Project
resource "aws_codebuild_project" "vprofile_build" {
  name          = "eprofile-build-job"
  description   = "Builds the Java vProfile application"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

resource "aws_codestarconnections_connection" "github_connection" {
  name          = "vprofile-github-conn"
  provider_type = "GitHub"
}

# 4. CodePipeline
resource "aws_codepipeline" "vprofile_pipeline" {
  name     = "vprofile-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  # Stage 1: Source (Updated to use CodeStarSourceConnection)
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS" 
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = "${var.github_owner}/${var.github_repo}"
        BranchName       = "main"
       
      }
    }
  }

  # Stage 2: Build (CodeBuild)
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.vprofile_build.name
      }
    }
  }

  # Stage 3: Deploy (Elastic Beanstalk)
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration = {
        ApplicationName = aws_elastic_beanstalk_application.Eprofile_bean_app.name
        EnvironmentName = aws_elastic_beanstalk_environment.elbeanstalk_env.name
      }
    }
  }
}