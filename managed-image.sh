#!/bin/bash

rg_name=cotiss-website
image_gallery_name=image_gallery
vm_to_copy=dev_web_02
image_name=base_image
publisher=cotiss
offer=offer
sku=sku

az sig create --resource-group $rg_name --gallery-name $image_gallery_name
VM_ID=$(az vm get-instance-view -g $rg_name -n $vm_to_copy --query id)

az sig image-definition create --resource-group $rg_name --gallery-name $image_gallery_name --gallery-image-definition $base_image --publisher $publisher --offer $offer --sku $sku --os-type Linux --os-state specialized

az sig image-version create --resource-group $rg_name --gallery-name $image_gallery_name --gallery-image-definition $base_image --gallery-image-version 1.0.0 --target-regions "westcentralus" --replica-count 1 --managed-image "/subscriptions/32c611dd-f2a6-4ceb-b69c-580b687754c3/resourceGroups/MyResourceGroup/providers/Microsoft.Compute/virtualMachines/image_gallery"
