module "bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "tbobm-bucket-pass-backup"
  acl    = "private"

  versioning = {
    enabled = true
  }
}

output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = module.bucket.s3_bucket_arn
}

output "s3_bucket_id" {
  description = "The ID of the created S3 bucket"
  value       = module.bucket.s3_bucket_id
}
