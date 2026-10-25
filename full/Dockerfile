ARG JAVA_VERSION
FROM docker.io/library/eclipse-temurin:${JAVA_VERSION} as build
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#     python3-minimal \
#     python3-pip \
#     python3-six \
#     && pip3 install --no-cache-dir \
#     mcstatus \
#     && apt-get remove -y \
#     python3-pip \
#     && apt-get autoremove -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && groupadd -g ${GROUP_ID} ${GROUP_NAME} \
#     && useradd -l -g ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}
ARG GROUP_NAME=minecraft
ARG GROUP_ID=25565
ARG USER_NAME=minecraft
ARG USER_ID=25565
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} \
    && useradd -l -g ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}
USER ${USER_ID}:${GROUP_ID}
WORKDIR /minecraft
ARG PAPER_URL
ARG PAPER_SHA256
ADD --checksum=sha256:${PAPER_SHA256} --chown=${USER_ID}:${GROUP_ID} ${PAPER_URL} paper.jar
RUN java -jar paper.jar nogui \
    && echo eula=true > eula.txt
EXPOSE 25565
# HEALTHCHECK CMD [ "mcstatus", "localhost", "ping" ]
ARG PAPER_ARGS
ENV PAPER_ARGS=${PAPER_ARGS}
ENV MEMORY=2048M
ENTRYPOINT exec java -Xms${MEMORY} -Xmx${MEMORY} $PAPER_ARGS -jar paper.jar nogui

ARG PAPER_BUILD
LABEL com.robjdavey.minecraft.server.build="${PAPER_BUILD}"

ARG PAPER_VERSION
LABEL com.robjdavey.minecraft.server.version="${PAPER_VERSION}"

LABEL org.opencontainers.image.authors="Rob Davey <884913+RobJDavey@users.noreply.github.com>"
LABEL org.opencontainers.image.description="A Minecraft Server running PaperMC (https://papermc.io) for plugin support and mcstatus (https://pypi.org/project/mcstatus/) for healthchecks"
LABEL org.opencontainers.image.source="https://github.com/RobJDavey/minecraft-server"
LABEL org.opencontainers.image.title="RobJDavey's Minecraft Server"
LABEL org.opencontainers.image.url="https://github.com/RobJDavey/minecraft-server"
