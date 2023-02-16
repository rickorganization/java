# First stage: complete build environment
FROM maven:3.8.3-openjdk-17 AS builder

# add pom.xml and source code
WORKDIR /project
COPY . .

# package jar
RUN mvn clean package -DskipTests

# Second stage: minimal runtime environment
From eclipse-temurin:17-jre-alpine

# To Properly handle PID1 events
RUN apk add dumb-init

# copy jar from the first stage
COPY --from=builder project/target/Pet-cleanic-0.0.1-SNAPSHOT.jar Pet-cleanic-0.0.1-SNAPSHOT.jar

EXPOSE 8080

CMD "dumb-init" "java" "-jar" "Pet-cleanic-0.0.1-SNAPSHOT.jar"