

# AWS Lambda Calculator PoC

This repository demonstrates a simple proof-of-concept (PoC) calculator application deployed on AWS using Terraform. The calculator performs basic arithmetic operations like addition, subtraction, multiplication, and division. It leverages AWS Lambda for computation and AWS API Gateway for handling HTTP requests. The HTML frontend and JavaScript code are hosted on a public S3 bucket, providing a simple user interface to interact with the calculator.

[Screen shot showing the HTML frontend](Screenshot.png)

## Prerequisites

- bash
- sed
- curl
- jq
- AWS Account with necessary [access credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys).
- AWS CLI v2.x.x
- Terraform v1.x.x

## Installation


1. **Install AWS CLI:** Follow the [official AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) to install the AWS CLI on your machine.
2. **Configure AWS CLI:** Run the following command to configure AWS CLI, and follow the prompts to input your AWS credentials (access key ID and secret access key) and default region:
3. **Install Terraform:** Follow the [official Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform on your machine.

    ```bash
    aws configure
    ```

## Usage

1. **Initialize Terraform:**

    Navigate to the directory containing the Terraform configurations and run the following command:

    ```bash
    terraform init
    ```

2. **Deploy Infrastructure:**

    Apply the Terraform configurations to provision the AWS infrastructure, including the public S3 bucket for hosting the HTML and JavaScript files:

    ```bash
    terraform apply
    ```

    After the command completes, it will output the URL of the S3 bucket hosting the frontend, and the URL of the API Gateway endpoint.

3. **Access the Calculator:**

    Open the provided S3 bucket URL in your web browser to access the HTML frontend, where you can perform arithmetic operations using the calculator.

## Testing AWS CLI Installation and Configuration

Ensure AWS CLI is correctly installed and configured with the following steps:

1. **Check AWS CLI Version:**

    ```bash
    aws --version
    ```

2. **List AWS S3 Buckets:**

    ```bash
    aws s3 ls
    ```

## Misc

https://repost.aws/knowledge-center/s3-access-denied-bucket-policy


SAM:
https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html
https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-invoke.html


terraform plan
terraform validate
terraform apply

alles wieder löschen:
terraform destroy



- S3
https://www.alexhyett.com/terraform-s3-static-website-hosting/

- Lambda
https://spacelift.io/blog/terraform-aws-lambda
https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway
- Api Gateway

endpoint config: html/endpoint.js

cleanup:
- hard-coded URL in output

