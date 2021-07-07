prep:
	@echo "Cleaning up unused dependencies and adding missing dependencies."
	@go mod tidy

list_execute_script_policies:
	aws iam list-attached-role-policies --role-name knock_script

list_role_policies:
	aws iam list-attached-role-policies --role-name $(role_name)

get_presigned_url:
	@go run presigned_url.go -b $(bucket) -k $(key) -r $(role)

assume_role:
	aws sts assume-role --role-arn "arn:aws:iam::067352809764:role/knock_script" --role-session-name AWSCLI-Session
