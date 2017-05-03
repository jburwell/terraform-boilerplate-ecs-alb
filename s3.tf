/**
 * Zone bucket for logs, terraform state, config, etc
 */
resource "aws_s3_bucket" "zone_bucket" {
  bucket = "${var.zone_bucket}"
  acl = "authenticated-read"
  force_destroy = true
  policy = <<EOL
{
  "Id": "",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow project access to the zone bucket",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.id}"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.zone_bucket}/${var.log_path}/*"
    }
  ]
}

EOL

  tags {
    Name = "${var.project_zone}"
    Group = "${var.project_zone}"
  }

  lifecycle {
    ignore_changes = ["policy"]
  }
}

# Template for ecs config
resource "template_file" "ecs_config" {
  template = "${file("files/ecs.config")}"

  vars {
    cluster_name = "${var.project}"
  }
}

/**
 * ECS config file
 */
resource "aws_s3_bucket_object" "ecs_config" {
    bucket = "${var.zone_bucket}"
    key = "${var.ecs_config_key}"
    content = "${template_file.ecs_config.rendered}"
    depends_on = [ "aws_s3_bucket.zone_bucket" ]
}

