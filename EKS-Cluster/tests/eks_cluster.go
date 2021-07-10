package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestPrivatePublicVPC(t *testing.T) {
	t.Parallel()

	clusterName := "test-cluster"
	nodeGroupName := "test-nodes"

	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"cluster_name": clusterName,
			"node_group_name": nodeGroupName,
		},
		VarFiles: []string{"varfile.tfvars"},
	})

	//defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)
}