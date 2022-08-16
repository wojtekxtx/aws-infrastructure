data "aws_ami" "debian_stable" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-20220310-944"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}

resource "aws_security_group" "this" {
  name        = "bastion-${var.environment}"
  description = "Bastion host SG"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_outgoing" {
  description       = "Allow outgoing"
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_vpc" {
  description       = "Allow incoming VPC"
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.debian_stable.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  user_data              = file("${path.module}/startup.sh")

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 20
    volume_type           = "gp2"
  }

  tags = {
    Name = "bastion_${var.environment}"
  }
}
