# https://github.com/docker-library/docs/blob/master/eclipse-temurin/README.md#simple-tags
# pick the `simple tags` for specify Linux environment (not windows!)
# for combined environment, use `shared tags` insteand (https://github.com/docker-library/docs/blob/master/eclipse-temurin/README.md#simple-tags)
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

ADD ./target/*.jar /app/JOB_APP_CODE_NAME.jar

ENTRYPOINT ["java","-jar","/app/JOB_APP_CODE_NAME.jar"]
