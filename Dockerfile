# Use an official Maven image to build the app
FROM maven:3.8.6-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and install dependencies (avoiding redundant Maven builds)
COPY pom.xml .

# Download dependencies and cache them
RUN mvn dependency:go-offline

# Copy the source code
COPY src /app/src

# Build the application and run tests
RUN mvn clean install -DskipTests

# Stage 2: Build the actual Docker image using a smaller JRE base image
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/my-maven-project-1.0-SNAPSHOT.jar /app/my-maven-project.jar

# Expose the port your application will run on (optional)
EXPOSE 8080

# Define the entry point for the Docker container
ENTRYPOINT ["java", "-jar", "/app/my-maven-project.jar"]

