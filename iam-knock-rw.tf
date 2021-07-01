// resource "aws_iam_role" "knock_s3_read_write" {
//   name               = "knock_s3_read_write"
//   assume_role_policy = "${data.aws_iam_policy_document.s3_read_write_policy.json}"
// }


# IAM policy that allows read-only access to the S3 bucket.
// resource "aws_iam_policy" "s3_read_policy" {
//     name   = "${var.policy_name_prefix}S3ReadWrite"
//     policy = "${data.aws_iam_policy_document.s3_read_only_policy.json}"
// }

// resource "aws_iam_policy_attachment" "knock_read_write" {
//   roles      = [aws_iam_role.knock_s3_read_write.name]
//   policy_arn = aws_iam_policy.s3_read_write_policy.arn
// }
