#!/bin/bash

rg_name=cotiss-website
vnet_name=cotiss-vnet
subnet_name=cotiss-subnet
public_ip_name=cotiss-IP
lb_name=cotiss-lb
lb_rule_name
front_end_name=cotiss-frontend
backend_Name=cotiss-backend
health_probe_name=cotiss-healthprobe
nsg_name=cotiss-nsg
nsg_rule_name=cotiss-nsg-rule

sshRule="cotiss-ssh-rule"

az network vnet create --resource-group $rg_name --location eastus --name $vnet_name --address-prefixes 10.1.0.0/16 --subnet-name $subnet_name --subnet-prefixes 10.1.0.0/24
echo "vnet created"

az network public-ip create --resource-group $rg_name --name $public_ip_name --sku Standard --zone 1 2 3
echo "public IP created"

az network lb create --resource-group $rg_name --name $lb_name --sku Standard --public-ip-address $public_ip_name --frontend-ip-name $front_end_name  --backend-pool-name $backend_Name
echo "lb created"

az network lb probe create --resource-group $rg_name --lb-name $lb_name --name $health_probe_name --protocol tcp --port 80
echo "network probe created"

az network lb rule create --resource-group $rg_name --lb-name $lb_name --name myHTTPRule --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $front_end_name --backend-pool-name $backend_Name --probe-name $health_probe_name --disable-outbound-snat true --idle-timeout 15 --enable-tcp-reset true
echo "network probe rules created"

az network nsg create --resource-group $rg_name --name $nsg_name
echo "nsg created"

az network nsg rule create --resource-group $rg_name --nsg-name $nsg_name --name $nsg_rule_name --protocol '*' --direction inbound --source-address-prefix '*' --source-port-range '*'  --destination-address-prefix '*'  --destination-port-range 80 --access allow --priority 200
echo "nsg rules created"


echo "Creating three NAT rules named $loadBalancerRuleSSH"
for i in `seq 1 2`; do
az network lb inbound-nat-rule create --resource-group $rg_name --lb-name $lb_name --name $sshRule$i --protocol tcp --frontend-port 422$i --backend-port 22 --frontend-ip-name $front_end_name
done



