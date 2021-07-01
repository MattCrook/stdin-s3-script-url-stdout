// # Provides an IAM role, allows anyone assuming the execution_role to read files n s3 bucket throught the attched managed policy.
// resource "aws_iam_role" "execution_role" {
//   name               = "execution_role"
//   assume_role_policy = "${data.aws_iam_policy_document.s3_read_only_policy.json}"
//   # managed_policy_arns = [aws_iam_policy.s3_read_policy.arn]
// }


// # Bucket policy to allow execution_role_arn to be able to read any file under the bucket you created.
// resource "aws_s3_bucket_policy" "bucket" {
//   bucket = aws_s3_bucket.bucket.id
//   policy = "${data.aws_iam_policy_document.s3_assumption.json}"
// }



# IAM policy that allows read-only access to the S3 bucket.
// resource "aws_iam_policy" "s3_read_policy" {
//     name   = "AmazonS3ReadOnlyAccess"
//     policy = "${data.aws_iam_policy_document.s3_read_only_policy.json}"
// }

// resource "aws_iam_policy_attachment" "s3_policy_attachment" {
//   name       = "s3-policy-attachment"
//   roles      = [aws_iam_role.execution_role.name]
//   policy_arn = aws_iam_policy.s3_read_policy.arn
// }
