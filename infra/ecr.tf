resource "aws_ecr_repository" "scrape" {
  name                 = local.scrape_ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "dbt" {
  name                 = local.dbt_ecr_repository_name
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

resource "aws_ecr_lifecycle_policy" "scrape" {
  repository = aws_ecr_repository.scrape.name
  policy     = data.aws_ecr_lifecycle_policy_document.keep_five_images.json
}

resource "aws_ecr_lifecycle_policy" "dbt" {
  repository = aws_ecr_repository.dbt.name
  policy     = data.aws_ecr_lifecycle_policy_document.keep_five_images.json
}
