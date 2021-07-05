# Devops Challenge

DevOps engineers at Knock often need to perform a variety of tasks with our AWS infrastructure that can be automated via scripting and infrastructure-as-code.

This project is an example of a script that reads from stdin a list of S3 keys with two parameters, the S3 bucket name and the IAM role to assume and outputs a list of pre-signed download URLs to stdout. Removes any duplicate entry and sort by the last modified date of the S3 key.

### Set Up Instructions

**Clone Repo**
* `git clone`
* `cd knock-devops-challenge`

**Set up Infrastructure**
* `terraform init`
* `terraform plan`
* `terraform apply`
* ***Optional***
  * Provision infrastructure with remote backend.
  * After running the above, uncomment the terraform backend block in `main.tf` and run `terraform init` and `terraform apply` again.


go mod tidy
go run s3_download.go

go get -u github.com/aws/aws-sdk-go/...

Create AWS Access Keys
https://console.aws.amazon.com/iam/home?#/home

* On the navigation menu, choose Users.
* Choose your IAM user name (not the check box).
* Open the Security credentials tab, and then choose Create access key.
* To download the key pair, choose Download .csv file. Store the keys



execution_role
    s3_assumption
        s3_read (policy)
            read_only_policy (read only on resource s3_bucket)



knock_s3_read_write_perm




knock_script
