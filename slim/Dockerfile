ARG JAVA_VERSION=16
FROM docker.io/openjdk:${JAVA_VERSION}-slim
ARG PAPER_VERSION
ARG PAPER_BUILD
ARG PAPER_DOWNLOAD=paper-${PAPER_VERSION}-${PAPER_BUILD}.jar
ARG USER_NAME=minecraft
ARG USER_ID=25565
ARG GROUP_NAME=minecraft
ARG GROUP_ID=25565
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3-minimal \
    python3-pip \
    python3-six \
    && pip3 install --no-cache-dir \
    mcstatus \
    && apt-get remove -y \
    python3-pip \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g ${GROUP_ID} ${GROUP_NAME} \
    && useradd -l -g ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}
USER ${USER_ID}:${GROUP_ID}
WORKDIR /minecraft
ADD --chown=${USER_ID}:${GROUP_ID} https://papermc.io/api/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/${PAPER_DOWNLOAD} paper.jar
RUN java -jar paper.jar nogui \
    && echo eula=true > eula.txt
EXPOSE 25565
HEALTHCHECK CMD [ "mcstatus", "localhost", "ping" ]
ENTRYPOINT [ "java", "-Xms2G", "-Xmx2G", "-jar", "paper.jar", "nogui" ]
LABEL com.robjdavey.minecraft.server.build="${PAPER_BUILD}"
LABEL com.robjdavey.minecraft.server.version="${PAPER_VERSION}"
LABEL org.opencontainers.image.authors="Robert Davey <robjdavey@gmail.com>"
LABEL org.opencontainers.image.description="A Minecraft Server running PaperMC (https://papermc.io) for plugin support and mcstatus (https://pypi.org/project/mcstatus/) for healthchecks"
LABEL org.opencontainers.image.source="https://github.com/RobJDavey/minecraft-server"
LABEL org.opencontainers.image.title="RobJDavey's Minecraft Server"
LABEL org.opencontainers.image.url="https://github.com/RobJDavey/minecraft-server"
