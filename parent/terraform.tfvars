# Local configuration - NOT in Git
project_name         = "petclinic"
environment          = "dev"
cloud_provider       = "azure"
deployment_type      = "webapp"

azure_resource_group = "terraform-petclinic-rg"
azure_location       = "francecentral"

docker_image        = "acrfrance4570.azurecr.io/petclinic:latest"
registry_server     = "acrfrance4570.azurecr.io"
registry_username   = "acrfrance4570"
registry_password   = "9UlazxQwyuSeXj+7omSqKaZVlyLhEtM6Gi/uat+Kgm+ACRDSsSMU"

gcp_project = "dummy-project-id"
