variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "namespace" {
  type        = string
  description = "CloudWatch namespace"
  default     = "kandidat-15"
}

variable "student_name" {
  type        = string
  description = "Name/id for resources"
  default     = "kandidat-15"
}

variable "dashboard_name" {
  type        = string
  description = "Name of CloudWatch dashboard"
  default     = "kandidat-15-sentiment-dashboard"
}

variable "alert_email" {
  type        = string
  description = "Email for SNS alerts"
}