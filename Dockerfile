#This is base image

FROM eclipse-temurin:21

WORKDIR /app

RUN mvn clean package -DskipTests

COPY target/java-sample-21-1.0.0.jar .

CMD ["java", "-jar", "java-sample-21-1.0.0.jar"]
