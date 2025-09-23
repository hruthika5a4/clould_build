#!/bin/bash
apt-get update
apt-get install -y apache2
echo "<h1>Hello from MIG v$(date +%s) instance $(hostname)</h1>" > /var/www/html/index.html
systemctl restart apache2
