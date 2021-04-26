package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func TestApiGateway(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../tf",
		Vars: map[string]interface{} {
			"indicationsfqdn": "https://mystifying-swirles-66e451.netlify.app/api/echo",
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	////defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	base := terraform.Output(t, terraformOptions, "baseURL")

	// Make an HTTP request to the instance and make sure we get back a 200 OK with the body "Hello, World!"
	url := fmt.Sprintf("%s/lambda", base)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "unauthorized", 30, 5*time.Second)
}

