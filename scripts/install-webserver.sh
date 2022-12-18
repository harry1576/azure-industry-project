#!/bin/sh

apt update
echo "Updated"

apt install nginx
echo "Installed nginx"

python3 -m venv .venv
source .venv/bin/activate
echo "Activate Virtual Env"

pip install flask
pip install pymongo
echo "Install Python Packages"

# scp the website files onto VM
