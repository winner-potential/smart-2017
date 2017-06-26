# Maven Component

Container is used to build, package and deploy the Apache Camel setup with maven. It is possible to deploy manually by navigating into javaeecamel and use maven commands. You have to change the hostname of your Wildfly with Camel within the pom.xml.

  mvn clean package wildfly:deploy
