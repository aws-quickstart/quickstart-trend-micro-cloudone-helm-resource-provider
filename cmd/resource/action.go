package resource

import (
	"log"

	"github.com/aws-cloudformation/cloudformation-cli-go-plugin/cfn/handler"
	helmprovider "github.com/aws-quickstart/quickstart-helm-resource-provider/cmd/resource"
	"github.com/aws/aws-sdk-go/aws"
)

const (
	HelmChartName  = "https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz"
)

func transformModel(req handler.Request, currentModel *Model) (*helmprovider.Model, error) {
	log.Println("Transforming the models...")
	newModel := &helmprovider.Model{}
	if err := req.Unmarshal(newModel); err != nil {
		log.Println("Error unmarshalling the request")
	}
	// Setting default chart to model
	if helmprovider.IsZero(currentModel.Chart) {
		newModel.Chart = aws.String(HelmChartName)
	}

	return newModel, nil
}
