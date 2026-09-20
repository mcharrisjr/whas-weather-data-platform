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
