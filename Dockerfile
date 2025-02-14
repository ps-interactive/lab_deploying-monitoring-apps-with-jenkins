# Use the official httpd runtime image as a parent image
FROM httpd:latest

# Copy the project files 
COPY index.html /usr/local/apache2/htdocs/index.html

# Simulate a failure in the container
#HEALTHCHECK CMD ["ping", "-c", "1", "localhost"] || exit 1 
HEALTHCHECK CMD ["touch", "/tmp/fake_file"] || exit 1

