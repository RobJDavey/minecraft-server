ARG JAVA_VERSION
FROM openjdk:${JAVA_VERSION}-slim
ARG PAPER_VERSION
ARG PAPER_BUILD
ARG PAPER_DOWNLOAD
ARG USER_NAME=minecraft
ARG USER_ID=25565
ARG GROUP_NAME=minecraft
ARG GROUP_ID=25565
RUN apt-get update \
    && apt-get install -y \
    python3-minimal \
    python3-pip \
    python3-six \
    && pip3 install \
    mcstatus \
    && apt-get remove -y \
    python3-pip \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -g ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}
USER ${USER_ID}:${GROUP_ID}
WORKDIR /minecraft
ADD --chown=${USER_ID}:${GROUP_ID} https://papermc.io/api/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/${PAPER_DOWNLOAD} paper.jar
RUN java -jar paper.jar nogui
RUN echo eula=true > eula.txt
EXPOSE 25565
HEALTHCHECK CMD [ "mcstatus", "localhost", "ping" ]
ENTRYPOINT [ "java", "-Xms2G", "-Xmx2G", "-jar", "paper.jar", "nogui" ]
