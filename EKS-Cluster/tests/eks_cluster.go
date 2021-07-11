package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	clusterName := "test-cluster"
	clusterFlavor := "balanced"

	nodeGroupName := "test-nodes"

	maxSize := 3
	minSize := 1
	desiredSize := 2

	enablePrivateEndpoint := true
	enablePublicEndpoint := true

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"cluster_name": clusterName,
			"cluster_flavor": clusterFlavor,
			"node_group_name": nodeGroupName,
			"max_size": maxSize,
			"min_size": minSize,
			"desired_size": desiredSize,
			"enable_private_endpoint": enablePrivateEndpoint,
			"enable_public_endpoint": enablePublicEndpoint,
		},
		VarFiles: []string{"varfile.tfvars"},
	})

	//defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)
}