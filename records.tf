resource "aws_route53_zone" "korede" {
  name = var.domain_name
 lifecycle {
  prevent_destroy = false
}

}


resource "aws_route53_record" "voting" {
  depends_on = [kubernetes_ingress_v1.voting, data.local_file.lb_hostname]
  zone_id = data.aws_route53_zone.example.zone_id  

  name    = "voting"
  type    = "CNAME"
  ttl     = "300"

  records = [data.local_file.lb_hostname.content]
}


resource "aws_route53_record" "microservice" {
  depends_on = [kubernetes_ingress_v1.microservice, data.local_file.lb_hostname]
  zone_id = data.aws_route53_zone.example.zone_id   

  name    = "microservice" 
  type    = "CNAME"
  ttl     = "300"

  records = [data.local_file.lb_hostname.content]
}


resource "aws_route53_record" "grafana" {
  depends_on = [kubernetes_ingress_v1.microservice, data.local_file.lb_hostname]
  zone_id = data.aws_route53_zone.example.zone_id   

  name    = "grafana" 
  type    = "CNAME"
  ttl     = "300"

  records = [data.local_file.lb_hostname.content]
}


resource "aws_route53_record" "prometheus" {
  depends_on = [kubernetes_ingress_v1.microservice, data.local_file.lb_hostname]
  zone_id = data.aws_route53_zone.example.zone_id   

  name    = "prometheus" 
  type    = "CNAME"
  ttl     = "300"

  records = [data.local_file.lb_hostname.content]
}


