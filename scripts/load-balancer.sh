#!/bin/bash

# Variable block
let "randomIdentifier=399110124" #"$RANDOM*$RANDOM"
location="East US"
resourceGroup="cotiss-load-balancer-website$randomIdentifier"
tag="load-balance-vms-across-availability-zones"
vNet="cotiss-vnet-lb-$randomIdentifier"
subnet="cotiss-subnet-lb-$randomIdentifier"
loadBalancerPublicIp="cotiss-public-ip-lb-$randomIdentifier"
ipSku="Standard"
zone="1 2 3"
loadBalancer="cotiss-load-balancer-$randomIdentifier"
frontEndIp="cotiss-front-end-ip-lb-$randomIdentifier"
backEndPool="cotiss-back-end-pool-lb-$randomIdentifier"
probe80="cotiss-port80-health-probe-lb-$randomIdentifier"
loadBalancerRuleWeb="cotiss-load-balancer-rule-port80-$randomIdentifier"
loadBalancerRuleSSH="cotiss-load-balancer-rule-port22-$randomIdentifier"
networkSecurityGroup="cotiss-network-security-group-lb-$randomIdentifier"
networkSecurityGroupRuleSSH="cotiss-network-security-rule-port22-lb-$randomIdentifier"
networkSecurityGroupRuleWeb="cotiss-network-security-rule-port80-lb-$randomIdentifier"
nic="cotiss-nic-lb-$randomIdentifier"
vm="cotiss-vm-web-lb-$randomIdentifier"
image="UbuntuLTS"
login="azureuser"





# Create a resource group
echo "Creating $resourceGroup in "$location"..."
az group create --name $resourceGroup --location "$location" --tags $tag

# Create a virtual network and a subnet.
echo "Creating $vNet and $subnet"
az network vnet create --resource-group $resourceGroup --name $vNet --location "$location" --subnet-name $subnet

# Create a zonal Standard public IP address for load balancer.
echo "Creating $loadBalancerPublicIp"
az network public-ip create --resource-group $resourceGroup --name $loadBalancerPublicIp --sku $ipSku

# Create an Azure Load Balancer.
echo "Creating $loadBalancer with $frontEndIP and $backEndPool"
az network lb create --resource-group $resourceGroup --name $loadBalancer --public-ip-address $loadBalancerPublicIp --frontend-ip-name $frontEndIp --backend-pool-name $backEndPool --sku $ipSku

# Create an LB probe on port 80.
echo "Creating $probe80 in $loadBalancer"
az network lb probe create --resource-group $resourceGroup --lb-name $loadBalancer --name $probe80 --protocol tcp --port 80

# Create an LB rule for port 80.
echo "Creating $loadBalancerRuleWeb for $loadBalancer"
az network lb rule create --resource-group $resourceGroup --lb-name $loadBalancer --name $loadBalancerRuleWeb --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $frontEndIp --backend-pool-name $backEndPool --probe-name $probe80

# Create two NAT rules for port 22.
echo "Creating three NAT rules named $loadBalancerRuleSSH"
for i in `seq 1 2`; do
az network lb inbound-nat-rule create --resource-group $resourceGroup --lb-name $loadBalancer --name $loadBalancerRuleSSH$i --protocol tcp --frontend-port 422$i --backend-port 22 --frontend-ip-name $frontEndIp
done

exit


# Create a network security group
echo "Creating $networkSecurityGroup"
az network nsg create --resource-group $resourceGroup --name $networkSecurityGroup

# Create a network security group rule for port 22.
echo "Creating $networkSecurityGroupRuleSSH in $networkSecurityGroup for port 22"
az network nsg rule create --resource-group $resourceGroup --nsg-name $networkSecurityGroup --name $networkSecurityGroupRuleSSH --protocol tcp --direction inbound --source-address-prefix '*' --source-port-range '*'  --destination-address-prefix '*' --destination-port-range 22 --access allow --priority 1000

# Create a network security group rule for port 80.
echo "Creating $networkSecurityGroupRuleWeb in $networkSecurityGroup for port 22"
az network nsg rule create --resource-group $resourceGroup --nsg-name $networkSecurityGroup --name $networkSecurityGroupRuleWeb --protocol tcp --direction inbound --priority 1001 --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 --access allow --priority 2000

# Create two virtual network cards and associate with public IP address and NSG.
echo "Creating three NICs named $nic for $vNet and $subnet"
for i in `seq 1 2`; do
az network nic create --resource-group $resourceGroup --name $nic$i --vnet-name $vNet --subnet $subnet --network-security-group $networkSecurityGroup --lb-name $loadBalancer --lb-address-pools $backEndPool --lb-inbound-nat-rules $loadBalancerRuleSSH$i
done

# Create two virtual machines, this creates SSH keys if not present.
echo "Creating three VMs named $vm with $nic using $image"
for i in `seq 1 2`; do
az vm create --resource-group $resourceGroup --name $vm$i --zone $i --nics $nic$i --image $image --admin-username $login --generate-ssh-keys --no-wait 
done

# List the virtual machines
az vm list --resource-group $resourceGroup
# </FullScript>

# echo "Deleting all resources"
# az group delete --name $resourceGroup -y
