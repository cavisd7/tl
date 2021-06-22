package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	vpcCIDR := "10.0.0.0/16"
	vpcTags := map[string]string{
		"kubernetes.io/cluster/myCluster": "shared"
	} 
	subnetCount := 2

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples"
		Vars: map[string]interface{}{
			"vpc_cidr": vpcCIDR, 
			"vpc_tags": vpcTags,
			"subnet_count": subnetCount,
		}
	})

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	actualVpcCIDR := terraform.Output(t, tfOptions, "vpc_cidr")
	actualVpcTags := terraform.OutputMap(t, tfOptions, "vpc_tags")
	actualSubnetCount := terraform.Output(t, tfOptions, "subnet_count")

	assert.Equal(t, vpcCIDR, actualVpcCIDR)
	assert.Equal(t, vpcTags, actualVpcTags)
	assert.Equal(t, subnetCount, actualSubnetCount)
}