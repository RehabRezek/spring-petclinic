FROM openjdk:17 as base 
WORKDIR /app
COPY . . 
RUN chmod +x ./mvnw
RUN ./mvnw  install package -X

FROM tomcat:9
WORKDIR webapps
#COPY --from=base /app/build/libs/3.0.0-petclinic-SNAPSHOT.war ./spring-petclinic

