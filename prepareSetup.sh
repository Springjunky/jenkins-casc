echo "This script prepares the .env File for docker-compose and the preloadPlugins.sh script"
JENKINS_VERSION="2.150.2"

read -e -p "Please enter your Jenkins-Version (2.150.2) : " -i $JENKINS_VERSION GIVEN_JENKINS_VERSION

MAJOR=$(echo $GIVEN_JENKINS_VERSION | cut -d. -f1)
MINOR=$(echo $GIVEN_JENKINS_VERSION | cut -d. -f2)
REVISION=$(echo $GIVEN_JENKINS_VERSION | cut -d. -f3)

echo "#Autogenerated, YES you can edit"
echo "MAJOR=$MAJOR" > jenkins.env
echo "MINOR=$MINOR" >> jenkins.env
echo "REVISION=$REVISION" >> jenkins.env

## Prepare Dockerfile
. ./jenkins.env
cp jenkins/Dockerfile.template jenkins/Dockerfile 
sed -i s#JENKINS_VERSION#${MAJOR}.${MINOR}.${REVISION}#g  jenkins/Dockerfile
sed -i s#CACHE_NAME#${MAJOR}.${MINOR}#g  jenkins/Dockerfile

echo "Dockerfile prepared run docker-compose up --build "

echo "If you want to preload all the Plugins and save time start preLoadPlugins.sh now"






