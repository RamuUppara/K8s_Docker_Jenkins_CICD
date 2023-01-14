terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
     kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "aws" {
  region = var.region

}

data "aws_eks_cluster_auth" "test-auth" {
  name = "demo"
}

provider "kubectl" {
  host                   = aws_eks_cluster.demo.endpoint

  cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority[0].data)

  token                  = data.aws_eks_cluster_auth.test-auth.token

  load_config_file       = false

}