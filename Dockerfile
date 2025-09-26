FROM httpd:2.4
COPY index.html /usr/local/apache2/htdocs/index.html

HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost/ || exit 1
