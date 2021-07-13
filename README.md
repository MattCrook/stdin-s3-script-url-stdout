# Terraform IAM Roles & Permissions

DevOps engineers often need to perform a variety of tasks with our AWS infrastructure that can be automated via scripting and infrastructure-as-code.

This project is an example of a script that reads from `stdin` an S3 Bucket, keys, and the IAM role to assume and outputs a pre-signed download URLs to `stdout`.

### Set Up Instructions

*This project assumes you have an AWS account, and have configured your aws credentials, either as environment variables or in ~/.aws/credentials.*

You can also put your credentials in your environment like:

```
export AWS_ACCESS_KEY_ID="<aws_access_key_id>"
export AWS_SECRET_ACCESS_KEY="<aws_secret_access_key>"
```

**Set up Infrastructure**

Cd into the `tf` directory.

* Run:
  * `terraform init`
  * `terraform plan`
  * `terraform apply`
* ***Step 2***
  * Provision infrastructure with remote backend. This will put the State file in the S3 bucket, which we will use later.
  * After running the above, uncomment the terraform backend block in `main.tf` and run:
    *  `terraform init`
    *  Type *yes* to confirm changing the backend from local to remote.
    *  The tfstate file should now be in the S3 bucket at `/tf/tfsate/terraform.tfstate`.

### Running the Scripts

Cd back out into root directory.

I made use of a `Makefile` in this project. You can choose to use it, or run the commands manually. The Makefile provides an easy way to standardize cli commands, as well as shorten and automate them, or made to be used in a CI/CD pipeline as *make targets*.

**Running with Make commands:**

* `make prep`
  * Set up Go environment and install any dependencies.
* To test and see the attached policies to a given role:
  * `make list_role_policies role_name=<ROLE_NAME>`
  * Example:
    * `make list_role_policies role_name=script`
    * This project will create three IAM roles:
      * execution_role
      * s3_read_write
      * script
* Run the Make target that runs the `Golang` script passing in the specified arguments:
  * `make get_presigned_url bucket=<BUCKET> key=<KEY> role=<IAM_ROLE>`
  * Example:
    * `make get_presigned_url bucket=devops-challenge-bucket key=tf/tfstate/terraform.tfstate role=arn:aws:iam::067352809764:role/script`

Running the Go script should output a presigned URL in which you can copy, and paste into a browser and be able to view the file. (In this case it is the state file).

**Running scripts manually:**

* `go mod tidy`
* `aws iam list-attached-role-policies --role-name <ROLE_NAME>`
* Run the script directly, passing the appropriate flags:
  * `go run presigned_url.go -b <BUCKET> -k <KEY> -r <ROLE>`
  * Example:
    * `go run presigned_url.go -b devops-challenge-bucket -k tf/tfstate/terraform.tfstate -r arn:aws:iam::067352809764:role/script`

### To Assume the execute_script Role

* `make assume_role`
* Then export the Global variables:
  * `export AWS_ACCESS_KEY_ID=RoleAccessKeyID`
  * `export AWS_SECRET_ACCESS_KEY=RoleSecretKey`
  * `export AWS_SESSION_TOKEN=RoleSessionToken`
* `aws sts get-caller-identity` - should now be the arn of `script`.

**Return to IAM user**
* `unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN`


### Tear Everything Down

Comment out the backend block in `main.tf` and run `terraform init` - This will return your backend to local. Then run `terraform destroy`.
