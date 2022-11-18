resource "aws_route53_zone" "base_domain" {
  name = "${var.domain}"
}



resource "aws_alb" "alb" {
  name            = "sap-alb"
  subnets         = data.aws_subnet_ids.Public.ids
  security_groups = [aws_security_group.https-sg.id]
  enable_deletion_protection = true
  internal        = false

  access_logs {
    bucket = aws_s3_bucket.log_bucket.id
    prefix = "ELB-logs"
    enabled = true
  }
  tags = {
    Name  =  "Application-1-elb"
  }
}

resource "aws_lb_listener" "lb" {
  load_balancer_arn = aws_alb.alb.arn

  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  port     = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.resource.id

  load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_alb.alb
  ]

  lifecycle {
    create_before_destroy = true
  }
}