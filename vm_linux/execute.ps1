az login
# az account set -s "DEV-crp-cio-hst-MJIL-CLDPRTC-11111"
# run this for the first time 
terraform init -backend-config="access_key=$(az storage account keys list --resource-group "rg-fabrykpoc1-core-kcl-eastus-002" --account-name "logslinuxvm" --query '[0].value' -o tsv)"
# for reconfigure
terraform init -reconfigure -backend-config="access_key=$(az storage account keys list --resource-group "rg-fabrykpoc1-core-kcl-eastus-002" --account-name "logslinuxvm" --query '[0].value' -o tsv)"
# run plan 
terraform plan
# apply
terraform apply
