FROM openjdk:16-alpine
ARG SERVER_VERSION
WORKDIR /minecraft
RUN apk add --update \
    py3-pip \
    py3-six \
    python3 \
    && pip3 install \
    mcstatus \
    && apk del \
    py3-pip \
    && rm -rf /var/cache/apk/*
ADD https://papermc.io/api/v1/paper/${SERVER_VERSION}/latest/download ./paper.jar
RUN java -jar paper.jar --nogui
RUN echo eula=true > eula.txt
EXPOSE 25565
HEALTHCHECK CMD [ "mcstatus", "localhost", "ping" ]
ENTRYPOINT [ "java", "-Xms2G", "-Xmx2G", "-jar", "paper.jar", "--nogui" ]
