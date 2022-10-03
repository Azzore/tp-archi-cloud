variable "account_number" {
  type        = number
  description = "Your account number"
}

variable "region" {
  type        = string
  description = "Region where to deploy resources"
  default     = "francecentral"
}