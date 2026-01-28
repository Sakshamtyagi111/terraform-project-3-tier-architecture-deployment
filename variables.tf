# variables.tf

variable "user_name" {
  description = "Database administrator username"
  type        = string
  sensitive   = true 
}

variable "user_pass" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}