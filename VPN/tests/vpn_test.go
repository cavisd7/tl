package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	vpcID := "vpc-12345"

	adminIPs := []string{
		"0.0.0.0/0", 
	}

	publicSubnets := []string{
		"subnet-12345", 
		"subnet-12345", 
	}

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"vpc_id": vpcID, 
			"admin_ips": adminIPs,
			"public_subnets": publicSubnets,
		},
	})

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)
}