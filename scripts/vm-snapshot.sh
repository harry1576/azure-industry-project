#!/bin/bash

rg_name=cotiss-website
vm_name=dev_web_01
disc_name=dev_web_disc_os


discID=$(az vm show --n $vm_name --resource-group $rg_name --query storageProfile.osDisk.managedDisk.id -o tsv)
echo $discID
az disk create --resource-group $rg_name --name $disc_name --sku Standard_LRS --size-gb 32 --source ${discID} --location "eastus"




