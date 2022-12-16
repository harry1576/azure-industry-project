#!/bin/bash

# Set up the webserver VM and opens port 80
# cloud-web-server-init.txt -> sets up nginx

rg_name=cotiss-website
vm_name=dev_web_01
zone_number=1

az group create --name cotiss-website --location eastus

az vm create --resource-group $rg_name --name $vm_name --image Debian --admin-username azureuser --generate-ssh-keys --zone $zone_number 

az vm open-port --port 80 --resource-group $rg_name --name $vm_name

ip=$(az vm show -d -g $rg_name -n $vm_name --query publicIps -o tsv)

echo 'VM Public IP:' $ip








