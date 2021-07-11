package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	defaultSubnetCount := 2

	vpcCIDR := "10.0.0.0/16"
	vpcTags := map[string]string{
		"kubernetes.io/cluster/myCluster": "shared",
	} 
	publicSubnetTags := map[string]string{
		"myTag": "myValue",
	}

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"vpc_cidr": vpcCIDR, 
			"vpc_tags": vpcTags,
			"public_subnet_tags": publicSubnetTags, 
		},
	})

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	actualVpcTags := terraform.OutputMap(t, tfOptions, "vpc_tags")
	actualPrivateSubnetIds := terraform.OutputList(t, tfOptions, "private_subnet_ids")
	actualPublicSubnetIds := terraform.OutputList(t, tfOptions, "public_subnet_ids")

	assert.Equal(t, vpcTags, actualVpcTags)
	assert.Equal(t, defaultSubnetCount * 2, len(actualPrivateSubnetIds) + len(actualPublicSubnetIds))
}