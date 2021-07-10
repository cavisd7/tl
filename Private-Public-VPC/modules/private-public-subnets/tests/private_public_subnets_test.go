package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	subnetCount := 2

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"subnet_count": subnetCount,
		},
		VarFiles: []string{"varfile.tfvars"},
	})

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)
}