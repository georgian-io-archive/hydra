variable "username_length" {
  description = "Number of characters in username"
  type        = number
}

variable "password_length" {
  description = "Number of characters in username"
  type        = number
}

variable "username_recovery_window" {
  description = "Number of days before Secret can be deleted"
  type        = number
}

variable "password_recovery_window" {
  description = "Number of days before Secret can be deleted"
  type        = number
}

variable "username_secret_name" {
  description = "Name of username storing secret"
  type        = number
}

variable "password_secret_name" {
  description = "Name of password storing secret"
  type        = number
}