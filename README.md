# azure-industry-project

## Overview

Cotiss leadership is looking for a simple website where employees can anonymously submit feedback. To encourage employees to share honestly, they want a randomly selected piece of existing feedback to be displayed on the site on each page load. The solution has been implemented using Microsoft Azure Cloud Services.


## Account Basics
<b> GOAL: </b> You can use the Azure CLI to retrieve information about your Azure account.

### Requirements

- Create an IAM user for your personal use.
- Set up MFA for your root user, turn off all root user API keys.
- Set up Billing Alerts for anything over a few dollars.
- Configure the Azure CLI for your user using API credentials.

### Steps

- First I created a directory for the Company and created an IAM user.
- I then created two resource groups one called cotiss-website and the other called budget-notification. 
- I set the budget limit to $8 and setup alerts for when the actual spending exceeds 80% of this or the forecasted exceeds 90%.
- I then configured the AZ CLI by using the command `az login` within my local terminal.


## Web Hosting Basics
<b> GOAL: </b> Create a simple HTML page served from your Virtual Machine instance.

### Requirements

- Deploy a Virtual Machine (VM) and host a simple static "Honest-Feedback Coming Soon" web page.
- Take a snapshot of your VM, delete the VM, and deploy a new one from the snapshot (ie. enable disaster recovery) 

### Steps

- To allow for easy reproducability I used azure scripts for deploying the virtual machine.
- I call the bash script by `bash create-static-website-vm.sh` which then generates a VM (called dev_web_01) and outputs the public IP.
- I can then use this IP address to ssh onto the VM `ssh azureuser@IP`.
- From here I do the following commands to update and install the webserver.
  - `sudo apt update`
  - `sudo apt install nginx`
- At this point I am able to view the default nginx home page.
- I modify the default page to display "Website Coming Soon" by editing the text file with `sudo nano /var/www/html/index.nginx-debian.html`
- It would be better if I could initalize the webserver all from a config scripts (however I couldn't manage to get this to work?).

- Now when I access the public IP address through a web-browser I see the "Website Coming Soon".
- To create a snap shot I first call the script bash `vm-snapshot.sh` , this creates a copy of the dev_web_01 OS disc.
- I then call the script `bash vm-from-snapshot` to create a new VM called dev_web_02 from the snapshot (and open port 80).
- Now I delete the old VM using `az vm delete --resource-group cotiss-website -name dev_web_01`
- Then viewing the new dev_web_02 IP we can see that is has the same page as the old VM (deployed correctly).


## Auto Scaling
<b> GOAL: </b> You can view a simple HTML page served from both of your Virtual Machine instances. You can turn one off and your website is still accessible.

## Requirements
- Put an Azure Load Balancer in front of that virtual machine and load balance between two Avaliablity Zones (one VM in each avaliablity zone)

### Steps
  - First I create a VM image, that can be used as a template for generating the VM instances.
  - 


  - First I delete everything within the resouce group, so I can regenerate the VM's inside an avaliablity set.
  - `az group delete --name cotiss-website`



## External Data
<b> GOAL: </b> Your auto scaled website can now load/save data to a database between users and sessions.

## Requirements
  - Create a Azure Cosmos DB table and experiment with loading and retrieving data manually, then do the same via a script on your local machine.
  - Refactor your static page into your Honest Feedback website (feel free to use Node, PHP, Python, or whichever programming language you like) which         reads/updates a list of Feedback entries in the Azure Azure Cosmos DB table. 

### Steps
  - First I setup a Azure Cosmos DB table and Mongo database using the bash script `bash create-db.sh` .
  - Then I test the DB has been correctly setup using the script `python db-test.py` (CRUD operations).
  - I can see that the data has been successfully integrated within the database (looked inside Azure portal).
  - I then develop a small simple web app and test this on my local machine.
  - Now I am ready to deploy this website across my VMs - to achieve this I use a bash script which installs the required packages on each VM and then copies the website contents onto their local drives.
  




