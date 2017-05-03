/**
 * ECS Cluster
 */
resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}"
}

/**
 * ECS Service
 */
# TODO Change the name of the resource to "main"
resource "aws_ecs_service" "api" {
  name = "api"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.api.arn}"
  desired_count = "${var.desired_capacity}"
  deployment_minimum_healthy_percent = 50
  iam_role = "${aws_iam_role.instance_role.arn}"

  # TODO Switch to SSL
  load_balancer {
    target_group_arn = "${aws_alb_target_group.web.id}"
    container_name = "api"
    container_port = 80
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

/**
 * Template for task definition
 */
resource "template_file" "api_container_definition" {
  template = "${file("files/task-definitions/api.json")}"

  vars {
    docker_repository = "${var.docker_repository}"
  }
}

/**
 * API Task definition for ECS Service
 */
resource "aws_ecs_task_definition" "api" {
  family = "${var.name_prefix}-api"
  container_definitions = "${template_file.api_container_definition.rendered}"
}

