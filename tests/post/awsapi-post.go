
package main

import (
	"context"

	"flag"
	"fmt"
	"io"
	"net/http"
	"strings"

	"github.com/aws/aws-sdk-go-v2/config"
	cip "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
)

// CIPAdminInitiateAuthAPI defines the interface for the AdminInitiateAuth function.
// We use this interface to test the function using a mocked service.
type CIPAdminInitiateAuthAPI interface {
	AdminInitiateAuth(ctx context.Context,
		params *cip.AdminInitiateAuthInput,
		optFns ...func(*cip.Options)) (*cip.AdminInitiateAuthOutput, error)
}

// MakeAuth creates an authorization.
// Inputs:
//     c is the context of the method call, which includes the AWS Region.
//     api is the interface that defines the method call.
//     input defines the input arguments to the service call.
// Output:
//     If successful, a AdminInitiateAuthOutput object containing the result of the service call and nil.
//     Otherwise, nil and an error from the call to AdminInitiateAuth.
func MakeAuth(c context.Context, api CIPAdminInitiateAuthAPI, input *cip.AdminInitiateAuthInput) (*cip.AdminInitiateAuthOutput, error) {
	return api.AdminInitiateAuth(c, input)
}

func main() {
	sb := readArgs()

	// Read shared AWS settings (from ~/.aws/config)
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		panic("configuration error, " + err.Error())
	}

	// Obtain Amazon Cognito service client
	client := cip.NewFromConfig(cfg)

	input := newInput(sb)

	result, err := MakeAuth(context.TODO(), client, input)
	if err != nil {
		fmt.Println("Got an error creating the authorization:")
		fmt.Println(err)
		return
	}

	fmt.Println("Created authorization for " + sb.Username)
	checkResult(sb, result)
	contact(sb)
}

// try endpoint
func contact(b *bag) {
	//DEBUG
	//fmt.Printf("tok rcvd: %s {\n%s\n}\n", sb.TokenType, sb.AccessToken)

	client := &http.Client{}
	req, err := http.NewRequest("POST", b.Endpoint, strings.NewReader(b.Payload))
	if err != nil {
		panic(err)
	}
	// specify the token in the request header
	req.Header.Add("Authorization", b.IdToken)
	if b.MimeType == "json" {
		req.Header.Set("Content-Type", "application/json")
	} else {
		//TODO AWS API Gateway returns UnsupportedMediaType
		/*
			req.Header.Set("Content-Type",
			"application/x-www-form-urlencoded")
		*/
	}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Svc response: %s\n", body)
}

func newInput(b *bag) *cip.AdminInitiateAuthInput {
	authParam := make(map[string]string)
	authParam["USERNAME"] = b.Username
	authParam["PASSWORD"] = b.Password
	return &cip.AdminInitiateAuthInput{
		AuthFlow:       types.AuthFlowTypeAdminNoSrpAuth,
		ClientId:       b.ClientId,
		UserPoolId:     b.PoolId,
		AuthParameters: authParam,
	}
}

// grab lengthy token
func checkResult(b *bag, o *cip.AdminInitiateAuthOutput) {
	if o.AuthenticationResult != nil {
		r := o.AuthenticationResult

		if r.TokenType == nil ||
			*r.TokenType != "Bearer" {
			panic("Token was not the expected type of Bearer")
		}

		b.TokenType = *r.TokenType
		if r.AccessToken != nil {
			b.AccessToken = *r.AccessToken
		}
		if r.IdToken != nil {
			b.IdToken = *r.IdToken
		}

	}
}

type bag struct {
	TokenType   string
	AccessToken string
	IdToken     string
	PoolId      *string
	ClientId    *string
	Username    string
	Password    string
	Endpoint    string
	MimeType    string
	Payload     string
}

func readArgs() *bag {

	clientId := flag.String("client", "", "Cognito app client ID")
	poolId := flag.String("pool", "", "Cognito user pool ID")
	name := flag.String("username", "r2d2@example.com", "Cognito user name")
	passwd := flag.String("password", "Passw0rd!", "Cognito user password")
	endpt := flag.String("endpt", "", "AWS API Gateway endpoint for testing")
	mime := flag.String("mime", "json", "MIME type toggles (Content-Type header)")
	payload := flag.String("payload", `{"id": "projid1234"}`, "Request body (JSON or form fields)")
	flag.Parse()

	if *poolId == "" || *clientId == "" {
		fmt.Println("You must supply the Cognito app client (-client CLIENT_ID)")
		fmt.Println("You must supply the Cognito User Pool (-pool POOL_ID)")
		panic("Program halt")
	}

	return &bag{
		PoolId:   poolId,
		ClientId: clientId,
		Username: *name,
		Password: *passwd,
		Endpoint: *endpt,
		MimeType: *mime,
		Payload:  *payload,
	}
}
