output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(module.s3_bucket.this[0].arn, "")
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = try(module.s3_bucket.this[0].region, "")
}