# ps-setup-cicd-jenkins



## Getting started

Clone the repo to get the code into your environment

```
git clone git@github.com:ps-interactive/lab_deploying-monitoring-apps-with-jenkins.git
```
# Start the Application

Change into the directory of the cloned repo, install the application requirements, and start the application.

```
cd lab_deploying-monitoring-apps-with-jenkins
docker build -t webserver .
docker run -d --name mywebserver -p 8080:80 
```

Visit http://localhost:8080
