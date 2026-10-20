# Stage 1: Build WAR with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: Tomcat 10.1 runtime
FROM tomcat:10.1-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/vmss.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

# Dynamically bind Tomcat to Render's $PORT (defaults to 8080 if not set)
CMD ["sh", "-c", "PORT=${PORT:-8080}; sed -i \"s/port=\\\"8080\\\"/port=\\\"$PORT\\\"/g\" conf/server.xml && bin/catalina.sh run"]
