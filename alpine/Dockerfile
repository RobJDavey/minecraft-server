ARG JAVA_VERSION
FROM openjdk:${JAVA_VERSION}-alpine
ARG PAPER_VERSION
ARG PAPER_BUILD
ARG PAPER_DOWNLOAD
ARG USER_NAME=minecraft
ARG USER_ID=25565
ARG GROUP_NAME=minecraft
ARG GROUP_ID=25565
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
ADD https://papermc.io/api/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/${PAPER_DOWNLOAD} paper.jar
RUN java -jar paper.jar nogui
RUN echo eula=true > eula.txt
RUN addgroup -S ${GROUP_NAME} -g ${GROUP_ID} && \
    adduser -S ${USER_NAME} -G ${GROUP_NAME} -u ${USER_ID} && \
    chown -R ${USER_NAME}:${GROUP_NAME} /minecraft
USER ${USER_ID}:${GROUP_ID}
EXPOSE 25565
HEALTHCHECK CMD [ "mcstatus", "localhost", "ping" ]
ENTRYPOINT [ "java", "-Xms2G", "-Xmx2G", "-jar", "paper.jar", "nogui" ]
