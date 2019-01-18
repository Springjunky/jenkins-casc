## jenkins-casc


Jenkins Tryout configuration-as-code plugin in a Docker-Container based enviroment.

#### What is configuration-as-code ?

This is a special plugin [configuration-as-code](https://plugins.jenkins.io/configuration-as-code)  

See https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/README.md 



## Run Locally 

start with 
```
prepareSetup.sh
```
to set your jenkins-version


after that just do a 
```
docker-compose up --build
```
and be patient, this will take a while.

Your Jenkins is avialabe at http://localhost:8080

 
### Test the configruation-as-code functionality

The file 
```
./jenkins-as-code/jenkinsconfig.yml
```
is mapped into the docker-container (/etc/jenkins-as-code/jenkinsconfig.yml)

Use your favorite editor to change the yml-based configuration and just do a reload in jenkins. 
 
 


