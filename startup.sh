#!/bin/bash

# Update packages
sudo apt-get update -y

# Install Apache web server
sudo apt-get install -y apache2

# Set default HTML page with hostname
echo "<h1>Hello from MIG instance $(hostname)</h1>" | sudo tee /var/www/html/index.html

# Enable Apache to start on boot
sudo systemctl enable apache2

# Start Apache service
sudo systemctl start apache2
