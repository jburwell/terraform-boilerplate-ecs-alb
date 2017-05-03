/**
 * Autoscaling group.
 */
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.name_prefix}-autoscaling-group"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  min_size             = "${var.cluster_min_size}"
  max_size             = "${var.cluster_max_size}"
  desired_capacity     = "${var.desired_capacity}"
  vpc_zone_identifier = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]

  tag {
    key = "Name"
    value = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key = "Group"
    value = "${var.project}"
    propagate_at_launch = true
  }
}

data "aws_ami" "stable_coreos" {
  most_recent = true

  filter {
    name   = "description"
    values = ["CoreOS stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] # CoreOS
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/files/cloud-config.yml")}"

  vars {
    aws_region         = "${var.region}"
    ecs_cluster_name   = "${aws_ecs_cluster.cluster.name}"
    # TODO convert to a variable
    ecs_log_level      = "info"
    # TODO convert to a veriable
    ecs_agent_version  = "latest"
    # TODO Implement cloudwatch support
    # Add --log-opt awslogs-group=${ecs_log_group_name} \ to cloud-config.yml
    # ecs_log_group_name = "${aws_cloudwatch_log_group.ecs.name}"
  }
}

/**
 * Launch configuration
 */
resource "aws_launch_configuration" "as_conf" {
  name                 = "${var.name_prefix}-web"
  image_id             = "${data.aws_ami.stable_coreos.image_id}"
  # TODO convert to a variable
  instance_type        = "t2.micro"
  key_name             = "${var.key_pair}"
  iam_instance_profile = "${aws_iam_instance_profile.instance_role.name}"
  security_groups      = ["${aws_security_group.web.id}"]
  user_data            = "${data.template_file.cloud_config.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  depends_on = ["aws_s3_bucket.zone_bucket", "aws_iam_role.instance_role"]
}

