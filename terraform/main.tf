module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2"

  bucket = "tbobm-bucket-pass-backup"
  acl    = "private"

  versioning = {
    enabled = true
  }
}

module "backup_user" {
  source    = "cloudposse/iam-system-user/aws"
  version   = "~> 0.23"
  namespace = "pass-backup"
  stage     = "prod"
  name      = "archived"

  inline_policies_map = {
    s3 = data.aws_iam_policy_document.s3_policy.json
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${module.bucket.s3_bucket_id}/*",
      "arn:aws:s3:::${module.bucket.s3_bucket_id}/"
    ]
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

output "aws_access_key_id" {
  description = "The AWS Access Key ID of the archive user"
  value       = module.backup_user.access_key_id
}

output "aws_secret_access_key" {
  description = "The AWS Secret Access Key of the archive user"
  value       = module.backup_user.secret_access_key
  sensitive   = true
}
