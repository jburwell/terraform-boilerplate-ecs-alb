/**
 * Security group for api
 */
resource "aws_security_group" "web" {
    name = "${var.name_prefix}-web"
    description = "security group for ${var.project} web"
    vpc_id = "${aws_vpc.main.id}"

    # TODO should SSH be exposed publicly?
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

/**
 * Security group for ALB
 */
resource "aws_security_group" "alb" {
    name = "${var.name_prefix}-alb"
    description = "security group for ${var.project} alb"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
