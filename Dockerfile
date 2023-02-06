FROM openjdk:11 as base 
WORKDIR /app
COPY . . 
RUN chmod +x ./gradlew
RUN ./gradlew build 

FROM tomcat:9
WORKDIR webapps
COPY --from=base /app/build/libs/3.0.0-petclinic-SNAPSHOT.war ./spring-petclinic

