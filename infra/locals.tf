locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  project_slug = replace(var.project_name, "-", "_")
}
