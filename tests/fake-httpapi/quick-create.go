// to setup AWS HTTP API (apigatewayv2) for JWT auth
package main

import (
	"context"

	"flag"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/config"
	gw2 "github.com/aws/aws-sdk-go-v2/service/apigatewayv2"
	gw2types "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types"
	cip "github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider"
	"github.com/aws/aws-sdk-go-v2/service/cognitoidentityprovider/types"
)

func main() {
	sb := readArgs()

	// Read shared AWS settings (from ~/.aws/config)
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		panic("configuration error, " + err.Error())
	}

	// Obtain Amazon service clients
	cipsdk := cip.NewFromConfig(cfg)
	gw2sdk := gw2.NewFromConfig(cfg)

	quickCreate(gw2sdk, sb)

	//TODO "rollback" when a step fails
	makeUserPool(cipsdk, sb)
	makePoolClient(cipsdk, sb)
	makeAuthorizer(gw2sdk, sb)
	makeIntegration(gw2sdk, sb)
	makeRoute(gw2sdk, sb)

	////makeStage(gw2sdk, sb)
}

func makeUserPool(c *cip.Client, b *bag) {
	input := poolInput(b)
	result, err := c.CreateUserPool(context.TODO(), input)
	if err != nil {
		fmt.Println("Got an error creating the user pool:")
		panic(err)
	}
	//extract new user pool ID
	p := result.UserPool
	b.UserPoolArn = p.Arn
	b.UserPoolId = p.Id
	fmt.Printf("UserPool ARN: %s\n", *p.Arn)
	fmt.Printf("UserPool ID: %s\n", *p.Id)
}

func makePoolClient(c *cip.Client, b *bag) {
	input := poolClientInput(b)
	result, err := c.CreateUserPoolClient(context.TODO(), input)
	if err != nil {
		fmt.Println("Got an error creating the pool client:")
		panic(err)
	}
	//extract new pool client ID
	pc := result.UserPoolClient
	b.ClientId = pc.ClientId
	fmt.Printf("PoolClient ID: %s\n", *pc.ClientId)
}

func quickCreate(c *gw2.Client, b *bag) {
	in := gatewayInput(b)
	result, err := c.CreateApi(context.TODO(), in)
	if err != nil {
		fmt.Println("Got an error using quick create:")
		panic(err)
	}
	//extract new gateway ID
	b.ApiEndpoint = result.ApiEndpoint
	b.ApiId = result.ApiId
	fmt.Printf("ApiId: %s", *b.ApiId)
	fmt.Printf(", ApiEndpoint: %s", *b.ApiEndpoint)
	fmt.Printf(", ApiName: %s", *result.Name)
	fmt.Println()
}

func makeAuthorizer(c *gw2.Client, b *bag) {
	in := authorizerInput(b)
	result, err := c.CreateAuthorizer(context.TODO(), in)
	if err != nil {
		fmt.Println("Got an error creating the authorizer:")
		panic(err)
	}
	// extract authorizer ID
	b.AuthorizerId = result.AuthorizerId
	fmt.Printf("Created authorizer %s\n", *b.AuthorizerId)
}

func makeIntegration(c *gw2.Client, b *bag) {
	in := integrationInput(b)
	result, err := c.CreateIntegration(context.TODO(), in)
	if err != nil {
		fmt.Println("Got an error creating the integration:")
		panic(err)
	}
	// extract integration ID
	b.IntegrationId = result.IntegrationId
	fmt.Printf("IntegrationId: %s, URI: %s\n",
		*b.IntegrationId, *result.IntegrationUri)
}

func makeRoute(c *gw2.Client, b *bag) {
	in := routeInput(b)
	result, err := c.CreateRoute(context.TODO(), in)
	if err != nil {
		fmt.Println("Got an error creating the route:")
		panic(err)
	}

	fmt.Printf("RouteId: %s, RouteKey: %s", *result.RouteId, *result.RouteKey)
	fmt.Printf(", Target: %s\n", *result.Target)
}

func makeStage(c *gw2.Client, b *bag) {
	in := stageInput(b)
	result, err := c.CreateStage(context.TODO(), in)
	if err != nil {
		fmt.Println("Got an error creating the stage:")
		panic(err)
	}

	fmt.Printf("StageName: %s\n", *result.StageName)
}

/*
func listIntegrations(c *gw2.Client, b *bag) {
	in := &gw2.GetIntegrationsInput {ApiId: b.ApiId}
	result, err := c.GetIntegrations(context.TODO(), in)
	if err != nil {
		fmt.Println("Got an error listing integrations:")
		panic(err)
	}
	for _,v := range result.Items {
		if *v.IntegrationUri == *b.IntegrationUri {
			b.IntegrationId = v.IntegrationId
			fmt.Printf("IntegrationId: %s\n", *v.IntegrationId)
		}
	}
}*/

func poolInput(b *bag) *cip.CreateUserPoolInput {
	aa := []types.VerifiedAttributeType{types.VerifiedAttributeTypeEmail}
	ua := []types.UsernameAttributeType{types.UsernameAttributeTypeEmail}
	return &cip.CreateUserPoolInput{
		PoolName:               b.UserPool,
		AutoVerifiedAttributes: aa,
		UsernameAttributes:     ua,
	}
}
func poolClientInput(b *bag) *cip.CreateUserPoolClientInput {
	xf := []types.ExplicitAuthFlowsType{
		types.ExplicitAuthFlowsTypeAllowAdminUserPasswordAuth,
		types.ExplicitAuthFlowsTypeAllowCustomAuth,
		types.ExplicitAuthFlowsTypeAllowUserPasswordAuth,
		types.ExplicitAuthFlowsTypeAllowUserSrpAuth,
		types.ExplicitAuthFlowsTypeAllowRefreshTokenAuth,
	}
	return &cip.CreateUserPoolClientInput{
		ClientName:        b.ClientName,
		UserPoolId:        b.UserPoolId,
		ExplicitAuthFlows: xf,
		GenerateSecret:    false,
	}
}
func gatewayInput(b *bag) *gw2.CreateApiInput {
	////descr := `API Gateway (v2) HTTP API + JWT Auth testing`
	return &gw2.CreateApiInput{
		Name:         b.ApiName,
		ProtocolType: gw2types.ProtocolTypeHttp,
		Target:       b.IntegrationUri,
		////Description:  &descr,
	}
}
func authorizerInput(b *bag) *gw2.CreateAuthorizerInput {
	is := []string{`$request.header.Authorization`}
	issuer := fmt.Sprintf(`https://cognito-idp.%s.amazonaws.com/%s`,
		*b.Region, *b.UserPoolId)

	conf := &gw2types.JWTConfiguration{
		Audience: []string{*b.ClientId},
		Issuer:   &issuer,
	}
	return &gw2.CreateAuthorizerInput{
		ApiId:            b.ApiId,
		AuthorizerType:   gw2types.AuthorizerTypeJwt,
		IdentitySource:   is,
		Name:             b.AuthorizerName,
		JwtConfiguration: conf,
	}
}
func integrationInput(b *bag) *gw2.CreateIntegrationInput {
	//descr := `HTTP_PROXY integration to known endpoint`
	method := `ANY`
	ver := `1.0`
	return &gw2.CreateIntegrationInput{
		ApiId:                b.ApiId,
		IntegrationType:      gw2types.IntegrationTypeHttpProxy,
		IntegrationMethod:    &method,
		IntegrationUri:       b.IntegrationUri,
		PayloadFormatVersion: &ver,
		ConnectionType:       gw2types.ConnectionTypeInternet,
		//Description:          &descr,
	}
}
func routeInput(b *bag) *gw2.CreateRouteInput {
	targ := fmt.Sprintf("integrations/%s", *b.IntegrationId)
	return &gw2.CreateRouteInput{
		ApiId:             b.ApiId,
		RouteKey:          b.RouteKey,
		AuthorizationType: gw2types.AuthorizationTypeJwt,
		AuthorizerId:      b.AuthorizerId,
		Target:            &targ,
	}
}
func stageInput(b *bag) *gw2.CreateStageInput {
	descr := `Stage for cognito-apigw HTTP API`

	return &gw2.CreateStageInput{
		ApiId:       b.ApiId,
		StageName:   b.StageName,
		AutoDeploy:  true,
		Description: &descr,
	}
}

type bag struct {
	UserPoolId     *string
	UserPoolArn    *string
	UserPool       *string
	ClientId       *string
	ClientName     *string
	ApiName        *string
	ApiEndpoint    *string
	ApiId          *string
	AuthorizerName *string
	AuthorizerId   *string
	Region         *string
	IntegrationId  *string
	IntegrationUri *string
	RouteKey       *string
	StageName      *string
}

func readArgs() *bag {

	clientName := flag.String("clientname", "cognito-apigw", "Name to give app client")
	poolName := flag.String("poolname", "cognito-apigw", "Name to give new Cognito user pool")
	apiName := flag.String("apiname", "cognito-apigw", "Name to give HTTP API")
	authName := flag.String("authname", "JwtAuthorizer", "Name to give authorizer")
	region := flag.String("region", "us-west-2", "AWS Region")
	intUri := flag.String("inturi", "", "Integration URI, fully-qualified URL")
	routeKey := flag.String("routekey", "ANY /indications", "Route Key")
	stageName := flag.String("stagename", "$default", "Name to give new stage")

	flag.Parse()

	if *intUri == "" {
		fmt.Println("The Integration URI is required (-inturi <fqurl>)")
		panic("Program HALT")
	}

	return &bag{
		UserPool:       poolName,
		ClientName:     clientName,
		ApiName:        apiName,
		AuthorizerName: authName,
		Region:         region,
		IntegrationUri: intUri,
		RouteKey:       routeKey,
		StageName:      stageName,
	}
}
