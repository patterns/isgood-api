package test

import (
	"crypto/tls"
	//"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func TestApiGateway(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../tf",
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	////defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	url := terraform.Output(t, terraformOptions, "baseURL")

	expect := "unauthorized"
	retry := 30
	sleep := 5*time.Second
	tlsconf := tls.Config{}
	// Make an HTTP request to the instance and make sure we get back a 200 OK with the body "Hello, World!"
	////url := fmt.Sprintf("%s/lambda", base)
	http_helper.HttpGetWithRetry(t, url, &tlsconf, 200, expect, retry, sleep)
}

