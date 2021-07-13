variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "devops-challenge-bucket"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "devops-challenge-locks"
}

variable "policy_name_prefix" {
  description = "The prefix to use for the IAM policy names"
  type        = string
  default     = "ExecuteRole"
}

variable "s3_key" {
  description = "The path to the state file in s3"
  type        = string
  default     = "tf/tfstate/terraform.tfstate"
}

variable "region" {
  type        = string
  default     = "us-east-1"
}
