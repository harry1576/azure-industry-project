#!/bin/bash

sudo apt update
echo "Updated"

sudo apt install nginx
sudo apt install gcc

echo "Installed nginx"

sudo apt-get install build-essential python
sudo apt-get install python-dev
sudo apt install libpython3-all-dev

apt-get install python3-venv
python3 -m venv .venv
source .venv/bin/activate
echo "Activate Virtual Env"

pip install --upgrade pip
pip install flask
pip install pymongo
pip install uwsgi
echo "Install Python Packages"

# scp the website files onto VM

scp -r website azureuser@172.174.97.199:~/

nano /etc/nginx/sites-enabled/flask_app


"

server {
    listen 80;
    
    location 


}



"
