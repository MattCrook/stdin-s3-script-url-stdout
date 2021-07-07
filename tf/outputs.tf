output "bucket_arn" {
    value       = aws_s3_bucket.bucket.arn
    description = "The Amazon Resource Name of the S3 bucket."
}

output "bucket_name" {
    value = aws_s3_bucket.bucket.bucket
}

output "dynamodb_table_name" {
    value       = aws_dynamodb_table.terraform_locks.name
    description = "The name of the DynamoDB table."
}

output "execution_role_arn" {
  description = "IAM role that is allowed to execute the script and read any file fromt the S3 bucket."
  value       = aws_iam_role.execution_role.arn
}

output "execution_role_name" {
  description = "IAM name of the role that is allowed to execute the script and read any file fromt the S3 bucket."
  value       = aws_iam_role.execution_role.name
}

output "knock_s3_read_write_perm_arn" {
  description = "IAM role that is allowed to perform read/write to s3 bucket"
  value       = aws_iam_role.knock_s3_read_write_perm.arn
}

output "knock_script_arn" {
  description = "IAM role with permissions to be able to run the script and that allows execution_role_arn role to assume it"
  value       = aws_iam_role.knock_script.arn
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
