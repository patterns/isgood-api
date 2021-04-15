# terraform
Terraform to write the deployment as configuration code

1. Sign up to AWS free tier
2. Install [Terraform]()
3. Deploy:
```
terraform init
terraform validate
terraform apply -var="indicationsfqdn=https://www.isgood.ai/"
```
4. Note the output value of baseURL
5. Test:
```
curl -d '{"id": "test123"}' -H "Content-Type: application/json"  -X POST baseURL/echo
curl -d '{"id": "test123"}' -H "Content-Type: application/json"  -X POST baseURL/lambda
```

## Credits

Minimum Lambda
 by [David Begin](https://www.davidbegin.com/the-most-minimal-aws-lambda-function-with-python-terraform/)

Terraform Tutorial
 by [HashiCorp](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway)

Chalice package format
 for [Terraform](https://aws.github.io/chalice/topics/tf.html)

Advanced Terraform with OpenAPI
 by [Rolf Streefkerk](https://dev.to/rolfstreefkerk/openapi-with-terraform-on-aws-api-gateway-17je)((LICENSE)[https://github.com/rpstreef/openapi-tf-example/blob/master/LICENSE])

Advanced Terraform
 by [AWS Samples](https://github.com/aws-samples/aws-ingesting-click-logs-using-terraform)([LICENSE](https://github.com/aws-samples/aws-ingesting-click-logs-using-terraform/blob/master/LICENSE))

