# Fake isgood_webAPI using AWS HTTP API
This version of the fake isgood_webAPI
 is different from the Chalice project (which is deployed on AWS
 with API Gateway's REST API.)

Using Sander Knapes article as the guide, the configuration
 is converted into AWS SDK Go calls and relies on the
 Create-Api quick create the most. It's equivalent to writing
 the AWS CLI calls into a BASH shell script.

![Quick-create diagram](sequence.svg)

## Quickstart
- Configure your AWS free tier (~/.aws files)
- Create the AWS API Gateway by `go run quick-create.go -inturi=YOUR_NETLIFY_ECHO_URL`
- Initiate user sign-in as in the article i.e., `aws cognito-idp sign-up`
- Confirm user as in the article i.e., `aws cognito-idp admin-confirm-sign-up`



## Credits

v2 AWS SDK for 
 [Golang](https://pkg.go.dev/github.com/aws/aws-sdk-go-v2)([LICENSE](https://pkg.go.dev/github.com/aws/aws-sdk-go-v2?tab=licenses))

Cognito JWTs and Amazon HTTP API
 by [Sander Knape](https://sanderknape.com/2020/08/amazon-cognito-jwts-authenticate-amazon-http-api/)

Dissecting HTTP APIs
 by [Tamás Sallai](https://advancedweb.hu/how-to-use-the-aws-apigatewayv2-api-to-add-an-http-api-to-a-lambda-function/)

chalice-cognito-auth
 [Python package](https://pypi.org/project/chalice-cognito-auth)

