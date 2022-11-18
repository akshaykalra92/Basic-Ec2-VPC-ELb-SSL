resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.key.private_key_pem
  email_address   = "akshaykalra92@gmail.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = "test.ak.cl"
  subject_alternative_names = ["*.test.ak.cl"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = aws_route53_zone.base_domain.zone_id
    }
  }

  depends_on = [acme_registration.registration]
}

resource "aws_acm_certificate" "cert" {
  private_key        =  acme_certificate.certificate.private_key_pem
  certificate_body   =  acme_certificate.certificate.certificate_pem
  certificate_chain  =  acme_certificate.certificate.issuer_pem
  depends_on         =  [acme_certificate.certificate,tls_private_key.key,acme_registration.registration]
}
