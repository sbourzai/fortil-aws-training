
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ASG with Launch template
resource "aws_launch_template" "training_ec2_launch_templ" {
  name_prefix   = var.env_prefix
  image_id      = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  user_data     = filebase64("user_data.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.training_subnet_2.id
    security_groups             = [aws_security_group.training_sg_for_ec2.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.env_prefix}-instance"
    }
  }
}

resource "aws_autoscaling_group" "training_asg" {
  # no of instances
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  # source
  target_group_arns = [aws_lb_target_group.training_alb_tg.arn]

  vpc_zone_identifier = [ # use private subnet
    aws_subnet.training_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.training_ec2_launch_templ.id
    version = "$Latest"
  }
}
