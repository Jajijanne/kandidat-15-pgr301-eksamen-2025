output "bucket_name" {
  value       = aws_s3_bucket.analysis.bucket
  description = "Name of the created S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.analysis.arn
  description = "ARN of the created S3 bucket"
}