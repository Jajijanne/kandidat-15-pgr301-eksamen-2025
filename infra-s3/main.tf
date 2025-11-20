terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Mangler credentials
  # Bruker local state isteden
  # backend "s3" {
  #  bucket = "pgr301-terraform-state"
  #  key    = "kandidat-15/infra-s3/terraform.tfstate"
  #  region = "eu-west-1"
  #}
}

provider "aws" {
  region = var.aws_region
}

# S3-bucket for analyseresultater
resource "aws_s3_bucket" "analysis" {
  bucket = var.bucket_name

  tags = {
    Project     = "AiAlpha"
    Purpose     = "analysis-data"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Slå på versjonering slik at vi kan se historikk
resource "aws_s3_bucket_versioning" "analysis" {
  bucket = aws_s3_bucket.analysis.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle regler som gjelder kun for filer under temporary files
resource "aws_s3_bucket_lifecycle_configuration" "analysis" {
  bucket = aws_s3_bucket.analysis.id

  rule {
    id     = "temporary-files"
    status = "Enabled"

    filter {
      prefix = var.temporary_prefix
    }

    # Flytt til billigere lagringsklasse etter x dager
    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER"
    }

    # Slett objekter etter y dager
    expiration {
      days = var.expiration_days
    }

    # Rydder opp i ufullstendige multipart-uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Ekstra regel som rydd opp gamle versjoner
  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# Hindre at bucketen kan bli offentlig ved et uhell
resource "aws_s3_bucket_public_access_block" "analysis" {
  bucket = aws_s3_bucket.analysis.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Kryptering på bucketen
resource "aws_s3_bucket_server_side_encryption_configuration" "analysis" {
  bucket = aws_s3_bucket.analysis.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}