terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}


// terraform {
//     backend "s3" {
//         bucket         = "devops-challenge-bucket"
//         key            = "tf/tfstate/terraform.tfstate"
//         region         = "us-east-1"
//         dynamodb_table = "devops-challenge-locks"
//         encrypt        = true
//     }
// }

resource "aws_s3_bucket" "bucket" {
    bucket  = var.bucket_name
    acl     = "private"

    // lifecycle {
    //     prevent_destroy = true
    // }

    # This is only here so we can destroy the bucket as part of this project and testing purposes.
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

    tags = {
        Name    = "S3-bucket"
        env     = "Dev"
        Vendor  = "Amazon"
    }
}


resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
# 3. write IAM role with read/write access to the foo/* prefix in the created bucket
# 4. script IAM role with permissions to be able to run the script and that allows execution_role_arn role to assume it.

# Provides an IAM role, allows anyone assuming the execution_role to read files in s3 bucket throught the attched managed policy.
resource "aws_iam_role" "execution_role" {
  name                = "execution_role"
  description         = "Allows S3 to call AWS services on your behalf"
  assume_role_policy  = data.aws_iam_policy_document.s3_assumption.json
  # managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}


resource "aws_iam_role" "s3_read_write_perm" {
  name               = "s3_read_write"
  description        = "Allows read/write access to the foo/* prefix in the created bucket"
  assume_role_policy = data.aws_iam_policy_document.s3_assumption.json
  # managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}


resource "aws_iam_role" "script" {
  name               = "script"
  description        = "IAM role with permissions to be able to run the script and that allows execution_role_arn role to assume it."
  assume_role_policy = data.aws_iam_policy_document.script_execution_assumption.json
}


# Allows execution_role_arn to be able to read any file under the S3 bucket created.
resource "aws_iam_policy" "s3_read" {
  name        = "${aws_s3_bucket.bucket.bucket}-s3-read"
  description = "Allows read access to specifed S3 bucket."
  policy      = "${data.aws_iam_policy_document.read_only_policy.json}"
}

resource "aws_iam_policy" "s3_read_write" {
  name        = "${aws_s3_bucket.bucket.bucket}-s3-read-write-access"
  description = "Allows read/write access to specifed S3 bucket."
  policy      = "${data.aws_iam_policy_document.s3_read_write_policy.json}"
}

resource "aws_iam_policy" "script" {
  name        = "${aws_s3_bucket.bucket.bucket}-s3-script-access"
  description = "Allows permissions to be able to run the script and that allows execution_role_arn role to assume it"
  policy      = "${data.aws_iam_policy_document.script_execution_perm.json}"
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_role_policy_attachment" "s3_read_write" {
  role       = aws_iam_role.s3_read_write_perm.name
  policy_arn = aws_iam_policy.s3_read_write.arn
}

resource "aws_iam_role_policy_attachment" "script" {
  role       = aws_iam_role.script.name
  policy_arn = aws_iam_policy.script.arn
}
