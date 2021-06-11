# TrendMicro::CloudOneContainer::Helm

An AWS CloudFormation resource type that deploys Trend Micro Cloud One Container Security into EKS clusters using helm.

## Prerequisites

### IAM role
An IAM role is used by CloudFormation to execute this resource type handler code.
A CloudFormation template to create the exeecution role is available
[here](./execution-role.template.yaml)

### Create an EKS cluster and provide CloudFormation access to the Kubernetes API
EKS clusters use IAM to allow access to the kubernetes API, as the CloudFormation resource types in this project
interact with the kubernetes API, the IAM execution role must be granted access to the kubernetes API. This can be done
in one of two ways:
* Create the cluster using CloudFormation: Currently there is no native way to manage EKS auth using CloudFormation
  (+1 [this GitHub issue](https://github.com/aws/containers-roadmap/issues/554) to help prioritize native support).
  For this reason we have published `AWSQS::EKS::Cluster`. Instructions on activation and usage can be found
  [here](https://github.com/aws-quickstart/quickstart-amazon-eks-cluster-resource-provider/blob/main/README.md).
* Manually: to allow this resource type to access the kubernetes API, follow the
  [instructions in the EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html) adding
  the IAM execution role created above to the `system:masters` group. (Note: you can scope this down if you plan to use
  the resource type to only perform specific operations on the kubernetes cluster)

## Activating the resource type
Activation can be done in one of the following ways: 
* [AWS console](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/registry/activate-extension?typeArn=arn:aws:cloudformation:us-east-1::type/resource/408988dff9e863704bcc72e7e13f8d645cee8311/TrendMicro-CloudOneContainer-Helm) 
* [AWS CLI](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/activate-type.html)
* [API](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_ActivateType.html)

Note that this must be done in each region you plan to use this resource type in.

## Usage
Properties and return values for the resource type are documented [here](./docs/README.md).

Documentation for the helm chart and it's values are available [here](https://github.com/trendmicro/cloudone-container-security-helm/blob/master/README.md).

## Examples

### Deploy Trend Micro Cloud One Container Security fetching credentials stored in AWS Secrets Manager
```yaml
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  CloudOneHelmRelease:
    Type: "TrendMicro::CloudOneContainer::Helm"
    Properties:
      ClusterID: my-cluster-name
      Name: trendmicro-cloudone
      Namespace: trendmicro-cloudone
      Values:
        cloudOne.admissionController.apiKey: {{resolve:secretsmanager:cloudone-api:SecretString:api-key}}
        cloudOne.runtimeSecurity.apiKey: {{resolve:secretsmanager:cloudone-api:SecretString:api-key}}
        cloudOne.runtimeSecurity.secret: {{resolve:secretsmanager:cloudone-api:SecretString:api-secret}}
```
