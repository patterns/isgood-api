package main

import (
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"math/rand"

	"time"
)

type rtype struct {
	ProjectId  string  `json:"projectId"`
	Indicators []dtype `json:"indicators"`
}
type dtype struct {
	IndicatorId     int  `json:"indicatorId"`
	AlignedStrength float32 `json:"alignedStrength"`
}
type qtype struct {
	ProjectId string `json:"projectId"`
	//Name string `json:"name"`
	//Description string `json:"description"`
	//ProjectImacts []string `json:"projectImpacts"`
	//DesiredOutcomes []string `json:"desiredOutcomes"`
}

func handler(request events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	word, err := extractField(request.Body)
	if err != nil {
		return &events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "JSON is missing the 'projectId' property",
		}, nil
	}

	var data []dtype
	// make arbitrary JSON for answer, to echo back
	rand.Seed(time.Now().Unix())
	permutations := rand.Perm(4)

	for _, pk := range permutations {
		item := dtype{
			IndicatorId:     pk + 1,
			AlignedStrength: rand.Float32(),
		}
		data = append(data, item)
	}
	payload := rtype{ProjectId: word, Indicators: data}
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
func extractField(body string) (word string, err error) {
	var qry qtype
	word = ""
	// expect JSON that contains a "id" field
	err = json.Unmarshal([]byte(body), &qry)
	if err != nil {
		return
	}
	return qry.ProjectId, nil
}
