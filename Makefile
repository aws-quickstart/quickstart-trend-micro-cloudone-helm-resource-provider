.PHONY: build test register clean

EX_ROLE ?= arn:aws:iam::<ACCID>:role/<ROLENAME>
LOG_ROLE ?= arn:aws:iam::<ACCID>:role/<ROLENAME>
TYPE_NAME ?= Snyk::Controller::Helm
TYPE_NAME_LOWER ?= $(shell echo $(TYPE_NAME) | tr '[:upper:]' '[:lower:]' | sed s/::/-/g)
BUCKET ?= awsqs-resource-type-ci

build:
	make -f makebuild  # this runs build steps required by the cfn cli

test:
	cfn generate
	env GOOS=linux go build -ldflags="-s -w" -o bin/handler cmd/main.go

clean:
	rm -rf bin

register:
	set -ex ; \
	aws s3 cp ./$(TYPE_NAME_LOWER).zip s3://$(BUCKET)/ ;\
	TOKEN=`aws cloudformation register-type \
		--type "RESOURCE" \
		--type-name  "$(TYPE_NAME)" \
		--schema-handler-package s3://$(BUCKET)/$(TYPE_NAME_LOWER).zip \
		--logging-config LogRoleArn=$(LOG_ROLE),LogGroupName=/cloudformation/registry/$(TYPE_NAME_LOWER) \
		--execution-role-arn $(EX_ROLE) \
		--region $(REGION) \
		--query RegistrationToken \
		--output text` ;\
	  while true; do \
		STATUS=`aws cloudformation describe-type-registration \
		  --registration-token $${TOKEN} \
		  --region $(REGION) --query ProgressStatus --output text` ;\
		if [ "$${STATUS}" == "FAILED" ] ; then \
		  aws cloudformation describe-type-registration \
		  --registration-token $${TOKEN} \
		  --region $(REGION) ;\
		  exit 1 ; \
		fi ; \
		if [ "$${STATUS}" == "COMPLETE" ] ; then \
		  ARN=`aws cloudformation describe-type-registration \
		  --registration-token $${TOKEN} \
		  --region $(REGION) --query TypeVersionArn --output text` ;\
		  break ; \
		fi ; \
		sleep 5 ; \
	  done ;\
	  aws cloudformation set-type-default-version --arn $${ARN} --region $(REGION)