resource "aws_acm_certificate" "acm_certificate" {
    depends_on = [aws_route53_zone.korede]
  domain_name = var.domain_name
  subject_alternative_names = ["*.korede.me"]
  validation_method = "DNS"
  
  lifecycle {
      create_before_destroy = true
  }
}

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






