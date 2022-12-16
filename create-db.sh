#!/bin/bash


let "randomIdentifier=$RANDOM*$RANDOM"

rg_name="cotiss-website"
account="msdocs-account-cosmos-harry" #needs to be lower case
database="customer-feedback"
location="eastus"


az cosmosdb create --name $account --resource-group $rg_name --kind MongoDB 
az cosmosdb mongodb database create --account-name $account --resource-group $rg_name --name $database

exit
echo $(az cosmosdb keys list --type connection-strings --resource-group $rg_name --name $account)




exit
# Create a SQL API database and container

# Variable block

location="East US"
failoverLocation="South Central US"
resourceGroup="msdocs-cosmosdb-rg-$randomIdentifier"
tag="create-sql-cosmosdb"
account="harry" #needs to be lower case
database="msdocs-db-sql-cosmos"
container="container1"
partitionKey="/zipcode"


# Create a Cosmos account for SQL API
echo "Creating $account"
az cosmosdb create --name $account --resource-group $rg_name 




# Create a SQL API database
echo "Creating $database"
az cosmosdb sql database create --account-name $account --resource-group $resourceGroup --name $database







# Define the index policy for the container, include spatial and composite indexes
printf ' 
{
    "indexingMode": "consistent", 
    "includedPaths": [
        {"path": "/*"}
    ],
    "excludedPaths": [
        { "path": "/headquarters/employees/?"}
    ],
    "spatialIndexes": [
        {"path": "/*", "types": ["Point"]}
    ],
    "compositeIndexes":[
        [
            { "path":"/name", "order":"ascending" },
            { "path":"/age", "order":"descending" }
        ]
    ]
}' > "idxpolicy-$randomIdentifier.json"

# Create a SQL API container
echo "Creating $container with $maxThroughput"
az cosmosdb sql container create --account-name $account --resource-group $resourceGroup --database-name $database --name $container --partition-key-path $partitionKey --throughput 400 --idx @idxpolicy-$randomIdentifier.json

# Clean up temporary index policy file
rm -f "idxpolicy-$randomIdentifier.json"

