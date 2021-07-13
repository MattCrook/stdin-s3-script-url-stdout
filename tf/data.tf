data "aws_iam_policy_document" "s3_assumption" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "read_only_policy" {
  statement {
    sid       = "S3ReadOnlyAccess"
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl"
      ]
    resources = ["${aws_s3_bucket.bucket.arn}"]
  }
}

data "aws_iam_policy_document" "s3_read_write_policy" {
  statement {
    sid       = "S3ReadWriteAccess"
    effect    = "Allow"
    actions   = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutBucketTagging",
      "s3:DeleteObjectTagging",
      "s3:DeleteObject"
      ]
    resources = ["${aws_s3_bucket.bucket.arn}"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "script_execution_assumption" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.execution_role.arn, data.aws_caller_identity.current.arn]
    }
  }
}

data "aws_iam_policy_document" "script_execution_perm" {
  statement {
    sid = "ScriptExecutionAccess"
    effect= "Allow"
    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetAccessPointPolicy",
      "s3:GetBucketPolicy",
      "s3:GetObjectVersion"
      ]
    resources = [
      "${aws_iam_role.script.arn}",
      "arn:aws:s3:us-east-1:067352809764:accesspoint/bucket",
      "arn:aws:s3:::devops-challenge-bucket/tf/tfstate/terraform.tfstate"
      ]
  }
}
