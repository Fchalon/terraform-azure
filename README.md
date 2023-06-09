# Terraform-azure-cloud
_Terraform automation for Azure Cloud_

## Prerequisites

* Install Terraform and Azure CLI
## vm_linux

### Synopsis
Terraform files to create a VM linux
### Procedure
Terraform treats any local directory referenced in the source argument of a module block as a module. A typical file structure for a new module is:
```
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```
To Deploy azure linux virtual machine using terraform,
| file | Description
|----------|-------------
| backend.tf|Store Terraform state in Azure Storage : To configure the backend state, you need the following Azure storage information: **storage_account_name**: The name of the Azure Storage account **container_name**: The name of the blob container **key**: The name of the state store file to be created.
| main.tf    | Contain the main set of configuration.
| variable.tf| Variables File.

### Deployment
* $az login
* $az account set -s "< name >"
* terraform init -backend-config="access_key=$(az storage account keys list --resource-group "< rg >" --account-name "< an >" --query '[0].value' -o tsv)"

**Reconfigure backend**
* terraform init -reconfigure -backend-config="access_key=$(az storage account keys list --resource-group "< rg >" --account-name "< an >" --query '[0].value' -o tsv)"

**Execute plan**
* $terraform plan
* $terraform apply

## vm_sl1_aio

### Synopsis

Terraform files for SL1 AIO vm creation.
Need a VHD of SL1 AIO (see **variables** section).

### Variables
Parameter | Choices/Defaults|Comments
----------|-----------------|--------
**prefix** (String) | "sl1" |
**hostname** (String) | "sl1aio" |
**location** (String) | "eastus" |
**vm_size** (String) | "Standard_A2_v2" |
**source_vhd_path** (URI) | <https://sl1storageaccount.blob.core.windows.net/sl1vhd/em7aio.vhd> |

### Deployment
* Move to vm_sl1_aio directory
* az login
* terraform init
* terraform plan
* terraform apply

## tags
In order to add tag on VM template for shutdown and power, insert this block in resource "site"

```
tags = {
  Autoshutdown = "20:00"
  Autostart = "08:00"
  Weekend = "Off"
 }
```


## Support
For any problem or error encountered using the playbook please open an issue in the issue section of this repository.

Team Support : https://kyndryl.sharepoint.com/sites/KYNDRYLMARKETFRANCETRANSFORMATIONINNOVATIONTEAM/SitePages/FR-DEVOPS-TEAM.aspx

Team Contact: FrenchDevOpsTeam@kyndryl.com
