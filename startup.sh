  GNU nano 7.2                                       startup.sh                                                 
#!/bin/bash
apt-get update
apt-get install -y apache2
echo "<h1>Hello from 12  MIG v123 instance $(hostname)</h1>" > /var/www/html/index.html
systemctl restart apache2
