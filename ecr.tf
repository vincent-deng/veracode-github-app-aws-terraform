provider "aws" {
  region = "eu-west-2"
}

resource "aws_ecr_repository" "veracode-github-app-repo" {
  name = "veracode-github-app-repo"
}

data "aws_ecr_repository" "veracode-github-app-repo" {
  name = aws_ecr_repository.veracode-github-app-repo.name
}

output "repository_url" {
  value = data.aws_ecr_repository.veracode-github-app-repo.repository_url
}