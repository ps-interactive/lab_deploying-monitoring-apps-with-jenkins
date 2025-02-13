# Use the official httpd runtime image as a parent image
FROM httpd:latest

# Copy the project files 
COPY index.html /usr/local/apache2/htdocs/index.html

# Simulate a failure to kick off the rollback 
RUN echo "Error" && exit 1
