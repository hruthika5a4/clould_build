# Use lightweight nginx base image
FROM nginx:alpine

# Copy your app code into nginx web root
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
