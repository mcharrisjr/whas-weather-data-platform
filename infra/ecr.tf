resource "aws_ecr_repository" "weather_scrape" {
  name                 = "${local.project}/scrape"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "weather_dbt" {
  name                 = "${local.project}/dbt"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_lifecycle_policy_document" "main" {
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

resource "aws_ecr_lifecycle_policy" "weather_scrape" {
  repository = aws_ecr_repository.weather_scrape.name
  policy     = data.aws_ecr_lifecycle_policy_document.main.json
}

resource "aws_ecr_lifecycle_policy" "weather_dbt" {
  repository = aws_ecr_repository.weather_dbt.name
  policy     = data.aws_ecr_lifecycle_policy_document.main.json
}
