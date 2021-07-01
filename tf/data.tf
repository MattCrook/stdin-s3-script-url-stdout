data "aws_iam_policy_document" "s3_read_only_policy" {
  statement {
    sid       = "AmazonS3ReadOnlyAccess",
    effect    = "Allow"
    actions   = ["s3:Get*", "s3:List*"]
    resources = [aws_s3_bucket.bucket.arn]
  }
}

data "aws_iam_policy_document" "s3_read_write_policy" {
  statement {
    sid       = "ListObjectsInBucket",
    effect    = "Allow"
    actions   = ["s3:List*"]
    resources = [aws_s3_bucket.bucket.arn]
  }

  statement {
    sid       = "AllObjectActions",
    effect    = "Allow"
    actions   = ["s3:*Object*"]
    resources = [aws_s3_bucket.bucket.arn]
  }
}

data "aws_iam_policy_document" "s3_assumption" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [aws_iam_role.execution_role.arn]
    }
  }
}

data "aws_iam_policy_document" "script_execution_assumption" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [aws_iam_role.execution_role.arn]
    }
  }
}
