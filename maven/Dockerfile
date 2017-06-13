FROM maven:3.5.0-jdk-8

COPY javaeecamel /usr/src/javaeecamel

WORKDIR /usr/src/javaeecamel

CMD ["mvn", "clean", "package", "wildfly:deploy"]
