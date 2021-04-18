# terraform
Terraform to write the deployment as configuration steps

## Quickstart
1. Sign up to AWS free tier
2. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
3. Deploy:
```
AWS_REGION=us-west-2 terraform init
AWS_REGION=us-west-2 terraform validate
AWS_REGION=us-west-2 terraform apply -var="indicationsfqdn=https://www.isgood.ai/"
```
4. Note the output value of baseURL
5. Test:
```
curl -d '{"id": "test123"}' -H "Content-Type: application/json"  -X POST baseURL/echo
curl -d '{"id": "test123"}' -H "Content-Type: application/json"  -X POST baseURL/lambda
```

6. Exercise token auth (on /lambda route) see the
 Sander Knape [guide](https://sanderknape.com/2020/08/amazon-cognito-jwts-authenticate-amazon-http-api/):
```
aws cognito-idp sign-up .....
aws cognito-idp admin-confirm-sign-up .....
aws cognito-idp initiate-auth .....
curl ..... -H "Authorization: ${TOKEN}" -X POST baseURL/lambda
```

7. Teardown
```
AWS_REGION=us-west-2 terraform destroy
```

## Credits

Minimum Lambda
 by [David Begin](https://www.davidbegin.com/the-most-minimal-aws-lambda-function-with-python-terraform/)

Terraform Tutorial
 by [HashiCorp](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway)

Chalice package format
 for [Terraform](https://aws.github.io/chalice/topics/tf.html)

Advanced Terraform with OpenAPI
 by [Rolf Streefkerk](https://dev.to/rolfstreefkerk/openapi-with-terraform-on-aws-api-gateway-17je)([LICENSE](https://github.com/rpstreef/openapi-tf-example/blob/master/LICENSE))

Advanced Terraform
 by [AWS Samples](https://github.com/aws-samples/aws-ingesting-click-logs-using-terraform)([LICENSE](https://github.com/aws-samples/aws-ingesting-click-logs-using-terraform/blob/master/LICENSE))

Cognito with Terraform
 by [Mark McDonnell](https://www.integralist.co.uk/posts/cognito/)

Cognito module
 by [mineiros](https://github.com/mineiros-io/terraform-aws-cognito-user-pool)

Cognito module
 by [Martin Donath](https://github.com/squidfunk/terraform-aws-cognito-auth)

Write Python instead of HCL
 [cdktf](https://learn.hashicorp.com/tutorials/terraform/cdktf)

