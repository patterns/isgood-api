package main

import (
	"fmt"
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type rtype struct {
	Indicators []dtype `json:"indicators"`
}
type dtype struct {
	Number      string `json:"id"`
	Description string `json:"description"`
}

// very ambiguous property name in this query to remind us to continue refining the oas
type qtype struct {
	Numbers []string `json:"numbers"`
}

// handler for /echo/foxtrot requests
func handler(request events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	nums, err := extractField(request.Body)
	if err != nil {
		return &events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "JSON array 'numbers' is missing ",
		}, nil
	}

	var data []dtype

	for _, num := range nums {
		item := dtype{
			Number:      num,
			Description: formatDescr(num),
		}
		data = append(data, item)
	}
	payload := rtype{Indicators: data}
	answer, _ := json.Marshal(payload)

	headers := map[string]string{
		"Content-Type":  "application/json",
		"Cache-Control": "public, max-age=300",
	}
	return &events.APIGatewayProxyResponse{
		StatusCode:      200,
		Headers:         headers,
		Body:            string(answer),
		IsBase64Encoded: false,
	}, nil
}

func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}

// grab a field value from the request body
func extractField(body string) (data []string, err error) {
	var qry qtype
	data = []string{}
	// expect JSON array "numbers"
	err = json.Unmarshal([]byte(body), &qry)
	if err != nil {
		return
	}
	return qry.Numbers, nil
}

func formatDescr(num string) string {
	return fmt.Sprintf("This is the %s indicator description.", num)
}
