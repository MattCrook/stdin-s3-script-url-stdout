prep:
	@echo "Cleaning up unused dependencies and adding missing dependencies."
	@go mod tidy

run_script:
	@go run s3_download.go

list_execute_script_policies:
	aws iam list-attached-role-policies --role-name knock_script

get_presigned_url:
	@go run presigned_url.go -b $(bucket) -k $(key) -r $(iam_role)

assume_role:
	aws sts assume-role --role-arn "arn:aws:iam::067352809764:role/knock_script" --role-session-name AWSCLI-Session


test:
	go run presigned_url.go -b knock-devops-challenge-bucket -k tf/tfstate/terraform.tfstate -r arn:aws:iam::067352809764:role/knock_script


#make get_presigned_url bucket=knock-devops-challenge-bucket key=tf/tfstate/terraform.tfstate iam_role=arn:aws:iam::067352809764:role/knock_script
#arn:aws:iam::067352809764:role/knock_s3_read_write
# export AWS_ACCESS_KEY_ID=ASIAQ7LUKKESOE27B7O7
# export AWS_SECRET_ACCESS_KEY=kvTEXY4On05ajczGO8U4zWp9oQPmiRm/LNtpGMyH
# export AWS_SESSION_TOKEN=RoleSessionToken
# {
#     "Credentials": {
#         "AccessKeyId": "ASIAQ7LUKKESOE27B7O7",
#         "SecretAccessKey": "kvTEXY4On05ajczGO8U4zWp9oQPmiRm/LNtpGMyH",
#         "SessionToken": "FwoGZXIvYXdzEGAaDD0GMXyyOPYVRqsvxCKyAbDG1SHrjyHF91tjqhVffOm3ySt31qgRyQxECctgE6oFr5CrrO6+MwT8vIFQfE39RnTaJc6/DEvYtr08XidIKuYWJbTvMzxee37OzrriTYA+CO/x17xOCGWgGngGKqXMUcROD1Y5E1EZaNQ6sJMswi3PVIJs9aLk1wr96Sr8x1uPG4lfqHsc/TT7IUAOJyjHMiAL3F6INss7w7QYUywhYXbfoGo6HqcqSc/umGMtnQA5v20ooIyOhwYyLXvzmSIpmwEvVKH88XsWEI0fR9IWYEECrOufGuX5mbUGVNemr7c3uOU5Ag2SBA==",
#         "Expiration": "2021-07-05T23:22:24+00:00"
#     },
#     "AssumedRoleUser": {
#         "AssumedRoleId": "AROAQ7LUKKESG6LBAKXW7:AWSCLI-Session",
#         "Arn": "arn:aws:sts::067352809764:assumed-role/knock_script/AWSCLI-Session"
#     }
# }
