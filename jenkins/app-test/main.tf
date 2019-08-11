provider "aws" {
  version = "~> 1.16.0"
  region = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile}"
}

terraform {
  required_version = "~> 0.11.7"
  # backend "s3" {
  #   bucket = "ucd-gs-app-config"
  #   key    = "test/terraform/app-test.tfstate"
  #   region = "us-west-2"
  #   encrypt = true
  # }
}

provider "template" {
  version = "~> 1.0.0"
}
