provider "aws" {
  region = "eu-west-2"
}

resource "aws_dynamodb_table" "veracode-github-app" {
  name           = "veracode-github-app"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "run_id"
  attribute {
    name = "run_id"
    type = "N"
  }
}