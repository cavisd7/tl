package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	publicSubnetCount := 2
	privateSubnetCount := 4
	multiNatGateway := true

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"public_subnet_count": publicSubnetCount,
			"private_subnet_count": privateSubnetCount,
			"multi_nat_gateway": multiNatGateway,
		},
		VarFiles: []string{"varfile.tfvars"},
	})

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)
}