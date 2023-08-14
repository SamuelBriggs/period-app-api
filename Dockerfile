#setting your build image
FROM maven:3.8.7 as build 

#creating working directory
WORKDIR /app

#copying all the source file into the container  
COPY . . 


#specify the what you want to use to run a container 
FROM eclipse-temurin:17

#youre copying the build image into the java container and it been copied into the app.jar
COPY --from=build app/target/*.jar /app.jar


# Expose the port that your Spring Boot application listens on
EXPOSE 8890

# Set the command to run your Spring Boot application when the container starts
CMD ["java", "-jar", "/app.jar"]
