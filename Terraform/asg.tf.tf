resource "aws_placement_group" "web" {
  name     = "web-pl"
  strategy = "partition"
}

data "aws_ami" "packer-ami" {
    most_recent = true

    filter {
        name = "name"
        values = ["packer-base*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["self"]  
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-lt-"
  image_id      = data.aws_ami.packer-ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_default_security_group.internal.id,
  ]
}

resource "aws_autoscaling_group" "web" {
  name                = "webscale"
  vpc_zone_identifier = [aws_subnet.a.id, aws_subnet.b.id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  placement_group     = aws_placement_group.web.id
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  alb_target_group_arn   = aws_lb_target_group.web.arn
}
