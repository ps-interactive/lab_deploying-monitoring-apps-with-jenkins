# Use the official httpd runtime image as a parent image
FROM httpd:latest

# Copy the project files 
#COPY index.html /usr/local/apache2/htdocs/index.html

# Comment the copy line above top simulate a failure and uncomment this line below
COPY indx.html /usr/local/apache2/htdocs/index.html

