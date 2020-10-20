terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}


provider "google" {
  version = "3.5.0"

  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "ai_platform_training_and_prediction_api" {
  project = var.project
  service = "ml.googleapis.com"

  disable_dependent_services = true
}


resource "google_project_service" "compute_engine_api" {
  project = var.project
  service = "compute.googleapis.com"

  disable_dependent_services = true
}


resource "google_project_service" "container_registry_api" {
  project = var.project
  service = "containerregistry.googleapis.com"

  disable_dependent_services = true
}
