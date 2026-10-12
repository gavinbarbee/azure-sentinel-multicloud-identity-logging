output "sentinel_role_arn" {
  description = "Paste into the Sentinel AWS S3 connector as the Role ARN."
  value       = aws_iam_role.sentinel_reader.arn
}

output "sqs_queue_url" {
  description = "Paste into the Sentinel AWS S3 connector as the SQS URL."
  value       = aws_sqs_queue.cloudtrail.url
}

output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrail.id
}

output "trail_arn" {
  value = aws_cloudtrail.identity.arn
}
