#!/bin/bash

# Deploy a Virtual Machine Scale Set with existing load balancer

rg_name=cotiss-website
vm_name=base #vm to copy
image_gallery_name=mygallery
image_defintion=website-base-img
offer=debian-10
publisher=debian
sku=10


scale_set_name=cotiss-scaleset

subscriptionID=$(az account show --query id --output tsv)
vmID=$(az vm get-instance-view -g $rg_name -n $vm_name --query id)

vnet_name=cotiss-vnet
subnet_name=cotiss-subnet
public_ip_name=cotiss-IP
lb_name=cotiss-lb
lb_rule_name=cotiss-lb-rule
front_end_name=cotiss-frontend
backend_Name=cotiss-backend
health_probe_name=cotiss-healthprobe
nsg_name=cotiss-nsg
nsg_rule_name=cotiss-nsg-rule





vm_image="/subscriptions/$subscriptionID/resourceGroups/$rg_name/providers/Microsoft.Compute/galleries/$image_gallery_name/images/$image_defintion"

az vmss create --resource-group $rg_name --name $scale_set_name --image $vm_image --generate-ssh-keys --instance-count 2 

az network lb rule create --resource-group $rg_name --name $lb_rule_name --lb-name ${scale_set_name}LB --backend-pool-name $backend_Name --backend-port 80 --frontend-ip-name $front_end_name --frontend-port 80 --protocol tcp
