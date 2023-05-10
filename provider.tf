provider "aws" {
}

/*
terraform {
  backend "s3" {
    bucket = "pponciano-s3-wordp"
    key    = "wordpress"
    region = "us-east-1"
  }
}
*/

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "random" {
}
