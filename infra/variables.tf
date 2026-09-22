variable "project_name" {
  description = "Project name."
  type        = string
  default     = "whas-weather"
}

variable "image_tag" {
  description = "ECR image tag."
  type        = string
  default     = "bootstrap"
}
