FROM openjdk:17

WORKDIR /app

COPY target/java-sample-21-1.0.0.jar .

CMD ["java", "-jar", "java-sample-21-1.0.0.jar"]
