#!/bin/bash


rg_name=cotiss-website
vm_name=base_vm
zone_number=1

az vm create --resource-group $rg_name --name $vm_name --image Debian --admin-username azureuser --generate-ssh-keys --zone $zone_number

az vm run-command invoke -g $rg_name -n $vm_name --command-id RunShellScript --script ./webserver.sh

az vm open-port --port 80 --resource-group $rg_name --name $vm_name

ip=$(az vm show -d -g $rg_name -n $vm_name --query publicIps -o tsv)

echo 'VM Public IP:' $ip

