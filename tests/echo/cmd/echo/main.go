package main

import (
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"math/rand"

	"time"
)

type rtype struct {
	Success bool  `json:"success"`
	Data    dtype `json:"data"`
}
type dtype struct {
	Word   string `json:"word"`
	Vector []int  `json:"vector"`
}
type qtype struct {
	Id string `json:"id"`
}

func handler(request events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	word, err := extractField(request.Body)
	if err != nil {
		return &events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "JSON is missing the 'id' property",
		}, nil
	}

	// make arbitrary JSON for answer, atm
	rand.Seed(time.Now().Unix())
	nums := rand.Perm(4)
	data := dtype{Word: word, Vector: nums}
	payload := rtype{Success: true, Data: data}
	answer, _ := json.Marshal(payload)

	headers := map[string]string{
		"Content-Type":  "application/json",
		"Cache-Control": "public, max-age=300",
	}
	return &events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers:    headers,
		////MultiValueHeaders: http.Header{"Set-Cookie": {"Ding", "Ping"}},
		Body:            string(answer),
		IsBase64Encoded: false,
	}, nil
}

func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}

// grab a field value from the request body
func extractField(body string) (word string, err error) {
	var qry qtype
	word = ""
	// expect JSON that contains a "id" field
	err = json.Unmarshal([]byte(body), &qry)
	if err != nil {
		return
	}
	return qry.Id, nil
}
