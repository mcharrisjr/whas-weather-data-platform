locals {
  ecr_repositories = {
    scrape = {
      name = "${var.project_name}/scrape"
    }
    dbt = {
      name = "${var.project_name}/dbt-build"
    }
  }
}

resource "aws_ecr_repository" "repositories" {
  for_each = local.ecr_repositories

  name                 = each.value.name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_lifecycle_policy_document" "keep_five_images" {
  rule {
    priority    = 1
    description = "Keep at most five images."

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 5
    }
  }
}

resource "aws_ecr_lifecycle_policy" "policies" {
  for_each = local.ecr_repositories

  repository = aws_ecr_repository.repositories[each.key].name
  policy     = data.aws_ecr_lifecycle_policy_document.keep_five_images.json
}
