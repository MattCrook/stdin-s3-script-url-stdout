data "aws_iam_policy_document" "s3_read_only_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:Get*", "s3:List*"]
    resources = ["*"]
  }

  statement {
    actions = ["sts:AssumeRole"]
    resources = [aws_s3_bucket.bucket.arn]
    effect = "Allow"
  }
}


data "aws_iam_policy_document" "s3_assumption" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}
