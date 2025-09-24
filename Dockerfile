# Use official Apache image
FROM httpd:2.4

# Copy your index.html to Apache web root
COPY index.html /usr/local/apache2/htdocs/index.html
