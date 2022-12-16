#!/bin/bash

rg_name="cotiss-website"
account="msdocs-account-cosmos-harry" #needs to be lower case
database="customer-feedback"
location="eastus"


az cosmosdb create --name $account --resource-group $rg_name --kind MongoDB 
az cosmosdb mongodb database create --account-name $account --resource-group $rg_name --name $database

echo $(az cosmosdb keys list --type connection-strings --resource-group $rg_name --name $account)


