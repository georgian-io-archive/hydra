variable "mlflow_container_repository" {
  description = "Container repository name"
  type        = string
}

variable "scan_on_push" {
  description = "Scan on docker image push"
  type        = bool
}