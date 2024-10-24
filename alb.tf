resource "aws_lb" "training_lb" {
  name               = "${var.env_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.training_sg_for_elb.id]
  subnets            = [aws_subnet.training_subnet_1.id, aws_subnet.training_subnet_1a.id]
  depends_on         = [aws_internet_gateway.training_gw]
}

resource "aws_lb_target_group" "training_alb_tg" {
  name     = "${var.env_prefix}-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_main.id
}

resource "aws_lb_listener" "training_front_end" {
  load_balancer_arn = aws_lb.training_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.training_alb_tg.arn
  }
}