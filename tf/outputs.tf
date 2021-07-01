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

// output "brave_arn" {
//     value       = aws_iam_user.example_iam[0].arn
//     description = "The ARN for user Matt"
// }

// output "all_arns" {
//      value       = aws_iam_user.example_iam[*].arn
//      description = "The ARNs for all iam users"
//  }

output "s3_read_only_policy_permissions" {
  value = data.aws_iam_policy_document.s3_read_only_policy.json
}

output "s3_assumption" {
  value = data.aws_iam_policy_document.s3_assumption.json
}

output "execution_role_arn" {
  description = "IAM role that is allowed to execute the script and read any file fromt the S3 bucket."
  value       = aws_iam_role.execution_role.arn
}
