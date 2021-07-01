terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}


// terraform {
//     backend "s3" {
//         bucket         = "knock-devops-challenge-bucket"
//         key            = "tf/terraform.tfstate"
//         region         = "us-east-2"
//         dynamodb_table = "knock-devops-challenge-locks"
//         encrypt        = true
//     }
// }

resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
    acl    = "private"

    # prevent accidental deletion of this bucket, so terraform destroy wil exit in an error.
    // lifecycle {
    //     prevent_destroy = true
    // }

    # This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production usage.
    force_destroy = true

    versioning {
        enabled = true
    }

    # Ensures state files are always encrypted on disk when stored in S3.
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

# Dynamodb table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
    name            = var.table_name
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}


# 1. execution role  - execution_role_arn
# 2. Bucket policy - to allow execution_role_arn to be able to read any file under the bucket you created
# 3. knock-write IAM role with read/write access to the foo/* prefix in the created bucket
# 4. knock-script IAM role with permissions to be able to run the script and that allows execution_role_arn role to assume it.

# Provides an IAM role, allows anyone assuming the execution_role to read files n s3 bucket throught the attched managed policy.
resource "aws_iam_role" "execution_role" {
  name               = "execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.s3_read_only_policy.json}"
  # managed_policy_arns = [aws_iam_policy.s3_read_policy.arn]
}


# Bucket policy to allow execution_role_arn to be able to read any file under the bucket you created.
resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = "${data.aws_iam_policy_document.s3_assumption.json}"
}

# knock-write IAM role with read/write access to the foo/* prefix in the created bucket
resource "aws_iam_role" "knock_s3_read_write" {
  name               = "knock_s3_read_write"
  assume_role_policy = "${data.aws_iam_policy_document.s3_read_write_policy.json}"
}

# knock-script IAM role with permissions to be able to run the script and that allows execution_role_arn role to assume it.
resource "aws_iam_role" "knock_script" {
  name               = "knock_script"
  assume_role_policy = "${data.aws_iam_policy_document.script_execution_assumption.json}"
}
