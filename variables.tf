# A project name
variable "project" {
  type = "string"
}

# AWS Access Key
variable "access_key" {
  type = "string"
}

# AWS Secret Key
variable "secret_key" {
  type = "string"
}

# AWS Region
variable "region" {
  type = "string"
}

# DNS root zone
variable "root_zone" { 
  type = "string"
}

# S3 bucket for tfstate
variable "tf_state_bucket" {
  type = "string"
}

variable "zone_bucket" {
  type = "string"
}

variable "cluster_min_size" {
  default = 1
}

variable "cluster_max_size" {
  default = 1
}

variable "desired_capacity" {
  default = 1
}

# Docker repository name for app container on ECS
variable "docker_repository" {
  default = "namespace/image_name"
}

variable "project_zone" {
  type = "string"
}

variable "name_prefix" {
  type = "string"
}

variable "cluster_name" {
  type = "string"
}

variable "root_path" {
  default = ""
}

variable "config_path" {
  default = "config"
}

variable "log_path" {
  default = "logs"
}

variable "key_pair" {
  type = "string"
}

variable "ecs_config_key" {
  default = "config/ecs.config"
}

# aws provider setting
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

