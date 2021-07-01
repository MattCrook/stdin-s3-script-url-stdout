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

# Provides an IAM role
resource "aws_iam_role" "execution_role" {
  name               = "execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.s3_assumption.json}"
}


# IAM policy that allows read-only access to the S3 bucket.
resource "aws_iam_policy" "s3_permissions" {
    name   = "${var.policy_name_prefix}S3ReadOnly"
    policy = "${data.aws_iam_policy_document.s3_read_only_policy.json}"
}


resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "s3-policy-attachment"
  roles      = [aws_iam_role.execution_role.name]
  policy_arn = aws_iam_policy.s3_permissions.arn
}



# Provides an IAM role inline policy. To allow execution_role to read everything in s3 bucket.
// resource "aws_iam_role_policy" "s3_policy" {
//   role   = aws_iam_role.execution_role.id
//   policy = data.aws_iam_policy_document.s3_read_only_policy.json
// }

// resource "aws_s3_bucket_policy" "bucket" {
//   bucket = aws_s3_bucket.bucket.id
//   policy = "${data.aws_iam_policy_document.s3_read_only_policy.json}"
// }

// resource "aws_iam_user_policy_attachment" "attachment" {
//   user       = aws_iam_user.new_user.name
//   policy_arn = aws_iam_role_policy.s3_permissions.arn
// }

// resource "aws_iam_user" "knock_iam_user" {
//   count = length(var.user_names)
//   name  = var.user_names[count.index]
// }


// resource "aws_iam_user_policy_attachment" "s3_read_only_attachment" {
//   user       = aws_iam_user.example_iam[0].name
//   policy_arn = aws_iam_policy.s3_read_only_policy.arn
// }
