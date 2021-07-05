# Devops Challenge

DevOps engineers at Knock often need to perform a variety of tasks with our AWS infrastructure that can be automated via scripting and infrastructure-as-code.

This project is an example of a script that reads from stdin a list of S3 keys with two parameters, the S3 bucket name and the IAM role to assume and outputs a list of pre-signed download URLs to stdout. Removes any duplicate entry and sort by the last modified date of the S3 key.

### Set Up Instructions

**Clone Repo**
* `git clone`
* `cd knock-devops-challenge`

**Set up Infrastructure**
Cd into the `tf` directory.

* `terraform init`
* `terraform plan`
* `terraform apply`
* ***Step 2***
  * Provision infrastructure with remote backend. This will put the State file in the S3 bucket, which we will use later.
  * After running the above, uncomment the terraform backend block in `main.tf` and run `terraform init` and `terraform apply` again.

**Running the Scripts**

Cd back out into root directory.

* `make prep`
* Run the Make target that runs the `Go` script passing in the specified arguments:
  * `make get_presigned_url`
  * Example:
    * `make get_presigned_url bucket=knock-devops-challenge-bucket key=tf/tfstate/terraform.tfstate iam_role=arn:aws:iam::067352809764:role/knock_script`










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
