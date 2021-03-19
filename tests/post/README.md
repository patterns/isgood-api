# POST to fake isgood_webAPI
This tool sends a POST request to exercise the OAS
  as implemented in the fake isgood_webAPI.
  It uses the AWS Cognito Identity Provider SDK
  to obtain the Bearer Tokens for the `Authorization:` header.

> [isgood API](https://github.com/for-good/isgood-api)

## Quickstart
```console
go run awsapi-post.go -client=YOUR_COGNITO_APP_CLIENTID \
                      -pool=YOUR_COGNITO_USER_POOLID \
                      -username=YOUR_COGNITO_USER \
                      -endpt=YOUR_AWS_API_ENDPOINT/indications

```



## Credits

v2 AWS SDK for 
 [Golang](https://pkg.go.dev/github.com/aws/aws-sdk-go-v2)([LICENSE](https://pkg.go.dev/github.com/aws/aws-sdk-go-v2?tab=licenses))

chalice-cognito-auth
 [Python package](https://pypi.org/project/chalice-cognito-auth)


