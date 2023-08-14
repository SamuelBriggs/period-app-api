# Stage 1: Build the Spring Boot application using Maven
FROM maven:3.8.7 as build

# Creating working directory
WORKDIR /app

# Copying source files into the container
COPY period-app .

# Building the application
RUN mvn clean package

# Stage 2: Create the final Docker image with the built application
FROM eclipse-temurin:17

# Creating working directory
WORKDIR /app

# Copying the built JAR file from the build stage
COPY --from=build /app/target/period-app-0.0.1-SNAPSHOT.jar /app/app.jar

# Exposing the port that your Spring Boot application listens on
EXPOSE 8890

# Set the command to run your Spring Boot application when the container starts
CMD ["java", "-jar", "app.jar"]
