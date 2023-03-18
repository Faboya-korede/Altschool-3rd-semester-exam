terraform {
  #required_version = "~> 1.0.3"

  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.5.3"
    }
  }
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  depends_on = [aws.aws_route53_zone.korede]
  algorithm = "RSA"
}


resource "acme_registration" "registration" {
  depends_on = [tls_private_key.private_key]  
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "faboyakorede@gmail.com" 
}


resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = data.aws_route53_zone.example.name
  subject_alternative_names = ["*.${data.aws_route53_zone.example.name}"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.example.zone_id
    }
  }

  depends_on = [acme_registration.registration]
}


resource "aws_acm_certificate" "certificate" {
  certificate_body  = acme_certificate.certificate.certificate_pem
  private_key       = acme_certificate.certificate.private_key_pem
  certificate_chain = acme_certificate.certificate.issuer_pem
}