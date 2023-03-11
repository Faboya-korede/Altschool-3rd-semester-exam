variable "secret_key" {}
variable "access_key" {}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "monitoring"
}
#variable "kube-version" {
 #   type = string
  #  default = "36.2.2"
#}

variable "vpc" {
  type    = string
  default = ""
}


module "kube" {
  source = "./kube-prometheus"
  kube-version = "36.2.0"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-1"
}


provider "helm" {
  kubernetes {
    host =  aws_eks_cluster.Alt-eks.endpoint
    token = data.aws_eks_cluster_auth.Alt-eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.Alt-eks.certificate_authority[0].data)
    #config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
    host =  aws_eks_cluster.Alt-eks.endpoint
    token = data.aws_eks_cluster_auth.Alt-eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.Alt-eks.certificate_authority[0].data)
    #config_path = pathexpand(var.kube_config)clear
}

