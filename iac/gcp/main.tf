module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 9.2"

  name                = "pf-test-1"
  random_project_id   = "true"
  org_id              = var.organization_id
  billing_account     = var.billing_account

  disable_services_on_destroy = "true"

  activate_apis = [
    "ml.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
  ]
}
