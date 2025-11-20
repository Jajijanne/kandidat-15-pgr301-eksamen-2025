variable "bucket_name" {
  description = "Name of the S3 bucket for analysis data"
  type        = string
}

variable "aws_region" {
  description = "Region for AWS"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name (e.g., production, development)"
  type        = string
  default     = "production"
}

variable "temporary_prefix" {
  description = "Prefix for temporary files"
  type        = string
  default     = "midlertidig/"
}

variable "transition_to_glacier_days" {
  description = "Number of days before transitioning temporary files to Glacier storage"
  type        = number
  default     = 30
}

variable "expiration_days" {
  description = "Number of days before deleting temporary files"
  type        = number
  default     = 90
}