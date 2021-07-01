variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "knock-devops-challenge-bucket"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "knock-devops-challenge-locks"
}


// variable "user_names" {
//   description = "Create IAM users with these names"
//   type        = list(string)
//   default     = ["Matt", "Bob"]
// }

variable "policy_name_prefix" {
  description = "The prefix to use for the IAM policy names"
  type        = string
  default     = "ExecuteRole"
}
