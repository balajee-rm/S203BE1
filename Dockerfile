# Stage 1: Build the backend WAR using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Package the WAR
RUN mvn clean package -DskipTests

# Stage 2: Tomcat to run the backend
FROM tomcat:9-jdk17

# Remove only the old backend app (keep frontend intact)
RUN rm -rf /usr/local/tomcat/webapps/back1

# Copy the new backend WAR
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/back1.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
