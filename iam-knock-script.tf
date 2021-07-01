// # knock-script IAM role with permissions to be able to run the script and that allows execution_role_arn role to assume it.
// resource "aws_iam_role" "knock_script" {
//   name               = "knock_script"
//   assume_role_policy = "${data.aws_iam_policy_document.script_execution_assumption.json}"
// }
