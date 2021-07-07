# Devops Challenge

DevOps engineers often need to perform a variety of tasks with our AWS infrastructure that can be automated via scripting and infrastructure-as-code.

This project is an example of a script that reads from stdin an S3 Bucket, keys, and the IAM role to assume and outputs a pre-signed download URLs to stdout.

### Set Up Instructions

**Clone Repo**
* `git clone git@github.com:MattCrook/stdin-s3-script-url-stdout.git`
* `cd knock-devops-challenge`

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

I made use of a `Makefile` in this project. You can choose to use it, or run the commands manually. The Makefile provides an easy way to standardize cli commands, as well as shorten and automate them so they are easier to remember, or made to be used in a CI/CD pipeline as *make targets*.

**Running with Make commands:**

* `make prep`
  * Set up Go environment and install any dependencies.
* To test and see the attached policies to a given role:
  * `make list_role_policies role_name=<ROLE_NAME>`
  * Example:
    * `make list_role_policies role_name=knock_script`
    * This project will create three IAM roles:
      * execution_role
      * knock_s3_read_write
      * knock_script
* Run the Make target that runs the `Go` script passing in the specified arguments:
  * `make get_presigned_url bucket=<BUCKET> key=<KEY> role=<IAM_ROLE>`
  * Example:
    * `make get_presigned_url bucket=knock-devops-challenge-bucket key=tf/tfstate/terraform.tfstate role=arn:aws:iam::067352809764:role/knock_script`

Running the Go script should output a presigned URL in which you can copy, and paste into a browser and be able to view the file. (In this case it is the state file).

**Running scripts manually:**

* `go mod tidy`
* `aws iam list-attached-role-policies --role-name <ROLE_NAME>`
* Run the script directly, passing the appropriate flags:
  * `go run presigned_url.go -b <BUCKET> -k <KEY> -r <ROLE>`
  * Example:
    * `go run presigned_url.go -b knock-devops-challenge-bucket -k tf/tfstate/terraform.tfstate -r arn:aws:iam::067352809764:role/knock_script`

### To Assume the execute_script Role

* `make assume_role`
* Then export the Global variables:
  * `export AWS_ACCESS_KEY_ID=RoleAccessKeyID`
  * `export AWS_SECRET_ACCESS_KEY=RoleSecretKey`
  * `export AWS_SESSION_TOKEN=RoleSessionToken`
* `aws sts get-caller-identity` - should now be the arn of `knock_script`.

**Return to IAM user**
* `unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN`


### Tear Everything Down

Comment out the backend block in `main.tf` and run `terraform init` - This will return your backend to local. Then run `terraform destroy`.
