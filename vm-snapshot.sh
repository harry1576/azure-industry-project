#!/bin/bash

rg_name=cotiss-website
vm_name=dev_web_01
zone_number=1
config_path=cloud-web-config.txt

az vm show -g cotiss-website -n vm-a

# Get managed disc id: /subscriptions/32c611dd-f2a6-4ceb-b69c-580b687754c3/resourceGroups/cotiss-website/providers/Microsoft.Compute/disks/vm-a_OsDisk_1_92b3be6b61484e21bc958f72a61132b3

az snapshot create -g cotiss-website --source "/subscriptions/32c611dd-f2a6-4ceb-b69c-580b687754c3/resourceGroups/cotiss-website/providers/Microsoft.Compute/disks/vm-a_OsDisk_1_92b3be6b61484e21bc958f72a61132b3" --name static-website-backup

az snapshot list -g cotiss-website -o table

# Create disc from snapshot:

az disk create --resource-group cotiss-website --name vm-b-disc --sku Standard_LRS --size-gb 32 --source '/subscriptions/32c611dd-f2a6-4ceb-b69c-580b687754c3/resourceGroups/cotiss-website/providers/Microsoft.Compute/disks/vm-a_OsDisk_1_92b3be6b61484e21bc958f72a61132b3'


az vm create --name vm-b --resource-group cotiss-website --attach-os-disk vm-b-disc --os-type linux

az vm open-port --port 80 --resource-group cotiss-website --name vm-b

