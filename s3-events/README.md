## Setup
- Install Terraform and AWS CLI
- Get AWS Access Key and Secret Key and set them as environment variables
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
- Create the buckets and the lambda function
```
terraform init
terraform apply
```
- Trigger the lambda function
```
aws lambda invoke --region=eu-central-1 --function-name=$(terraform output -raw function_name) response.json
```
- Check the response
```
cat response.json
```
https://github.com/acantril/learn-cantrill-io-labs/tree/master/00-aws-simple-demos/aws-lambda-s3-events