package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	desiredCapacity := 2

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"desired_capacity": desiredCapacity,
		},
		VarFiles: []string{"varfile.tfvars"},
	})

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)
}