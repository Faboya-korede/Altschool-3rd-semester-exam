#variable "access_key" {
 # type = string
  #default = ""
#}

#variable "secret_key" {
 # type = string 
 # default = ""
#}


variable "namespace" {
  type    = string
  default = "monitoring"
}


variable "vpc" {
  type    = string
  default = ""
}


provider "aws" {
  region     = "us-east-1"
}


provider "helm" {
  kubernetes {
     host =  aws_eks_cluster.Alt-eks.endpoint
     token = data.aws_eks_cluster_auth.Alt-eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.Alt-eks.certificate_authority[0].data)
    #config_path = var.kube_config 
  }
}

provider "kubernetes" {
    host =  aws_eks_cluster.Alt-eks.endpoint
    token = data.aws_eks_cluster_auth.Alt-eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.Alt-eks.certificate_authority[0].data)
    #config_path = pathexpand(var.kube_config)
}




provider "kubectl" {
    load_config_file = false
    host =  aws_eks_cluster.Alt-eks.endpoint
    token = data.aws_eks_cluster_auth.Alt-eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.Alt-eks.certificate_authority[0].data)
    #config_path = pathexpand(var.kube_config)
}
