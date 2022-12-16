#!/bin/bash

rg_name=cotiss-website
new_vm_name=dev_web_02
disc_name=dev_web_disc_os

az vm create --name $new_vm_name --resource-group $rg_name --attach-os-disk $disc_name --os-type linux
az vm open-port --port 80 --resource-group $rg_name --name $new_vm_name
