#!/bin/bash

rg_name=cotiss-website
vm_name=base #vm to copy
image_gallery_name=mygallery
image_defintion=website-base-img
offer=debian-10
publisher=debian
sku=10

subscriptionID=$(az account show --query id --output tsv)
vmID=$(az vm get-instance-view -g $rg_name -n $vm_name --query id)

echo $("/subscriptions/$subscriptionID/resourceGroups/$rg_name/providers/Microsoft.Compute/virtualMachines/$vm_name")
echo $subscriptionID


az sig image-definition create --resource-group $rg_name --gallery-name $image_gallery_name --gallery-image-definition $image_defintion --publisher $publisher --offer $offer --sku $sku --os-state specialized --os-type Linux

az sig image-version create --resource-group $rg_name --gallery-name $image_gallery_name --gallery-image-definition $image_defintion --gallery-image-version 1.0.0 --managed-image "/subscriptions/$subscriptionID/resourceGroups/$rg_name/providers/Microsoft.Compute/virtualMachines/$vm_name"


