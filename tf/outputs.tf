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

output "s3_read_only_policy_permissions" {
  value = data.aws_iam_policy_document.s3_read_only_policy.json
}

output "s3_assumption" {
  value = data.aws_iam_policy_document.s3_assumption.json
}

output "s3_read_write_policy" {
  value = data.aws_iam_policy_document.s3_read_write_policy.json
}

output "script_execution_assumption" {
  value = data.aws_iam_policy_document.script_execution_assumption.json
}

output "execution_role_arn" {
  description = "IAM role that is allowed to execute the script and read any file fromt the S3 bucket."
  value       = aws_iam_role.execution_role.arn
}

output "execution_role_name" {
  description = "IAM name of the role that is allowed to execute the script and read any file fromt the S3 bucket."
  value       = aws_iam_role.execution_role.name
}

// output "knock_s3_read_write_perm_arn" {
//   description = "IAM role that is allowed to perform read/write to s3 bucket"
//   value       = aws_iam_role.knock_s3_read_write_perm.arn
// }
