module github.com/aws-quickstart/quickstart-trend-micro-cloudone-helm-resource-provider

go 1.16

require (
	github.com/aws-cloudformation/cloudformation-cli-go-plugin v1.0.3
	github.com/aws-quickstart/quickstart-helm-resource-provider v1.2.0
	github.com/aws/aws-lambda-go v1.26.0
	github.com/aws/aws-sdk-go v1.40.43
	github.com/docker/docker v17.12.0-ce-rc1.0.20200916142827-bd33bbf0497b+incompatible // indirect
	github.com/stretchr/testify v1.7.0
)

replace (
	github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d
	github.com/docker/docker => github.com/moby/moby v17.12.0-ce-rc1.0.20200618181300-9dc6525e6118+incompatible
)
