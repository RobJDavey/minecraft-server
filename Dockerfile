ARG JAVA_VERSION=25
ARG BASE_SUFFIX=""
# A mirror of the Docker Hub official images, without Docker Hub's pull limits
ARG BASE_REGISTRY=public.ecr.aws/docker/library

FROM --platform=$BUILDPLATFORM ${BASE_REGISTRY}/eclipse-temurin:${JAVA_VERSION}${BASE_SUFFIX} AS build
WORKDIR /opt/paper
ARG PAPER_URL
ARG PAPER_SHA256
ADD --checksum=sha256:${PAPER_SHA256} ${PAPER_URL} paper.jar
# Let Paperclip download and patch the server, then write the classpath and
# main class to an argument file so the server can be run without Paperclip.
# The classpath follows Paperclip's order (server jar first), because the
# server jar overrides some library classes.
RUN java -DbundlerRepoDir=/opt/paper -Dpaperclip.patchonly=true -jar paper.jar \
    && cd /tmp \
    && jar xf /opt/paper/paper.jar META-INF/versions.list META-INF/libraries.list \
    && server_jar=/opt/paper/versions/$(cut -f 3 META-INF/versions.list) \
    && class_path=$({ cut -f 3 META-INF/versions.list | sed 's|^|/opt/paper/versions/|'; \
        cut -f 3 META-INF/libraries.list | sed 's|^|/opt/paper/libraries/|'; } | paste -sd : -) \
    && jar xf "$server_jar" META-INF/MANIFEST.MF \
    && main_class=$(sed -n 's/^Main-Class: //p' META-INF/MANIFEST.MF | tr -d '\r') \
    && printf -- '-cp %s\n%s\n' "$class_path" "$main_class" > /opt/paper/server.args

FROM ${BASE_REGISTRY}/eclipse-temurin:${JAVA_VERSION}-jre${BASE_SUFFIX}
ARG GROUP_NAME=minecraft
ARG GROUP_ID=25565
ARG USER_NAME=minecraft
ARG USER_ID=25565
RUN if command -v useradd >/dev/null; then \
        groupadd -g ${GROUP_ID} ${GROUP_NAME} \
        && useradd -l -g ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}; \
    else \
        addgroup -g ${GROUP_ID} ${GROUP_NAME} \
        && adduser -D -G ${GROUP_NAME} -u ${USER_ID} ${USER_NAME}; \
    fi
COPY --from=build /opt/paper/libraries /opt/paper/libraries
COPY --from=build /opt/paper/versions /opt/paper/versions
COPY --from=build /opt/paper/server.args /opt/paper/server.args
USER ${USER_ID}:${GROUP_ID}
WORKDIR /minecraft
VOLUME /minecraft
EXPOSE 25565
ARG PAPER_ARGS
ENV PAPER_ARGS=${PAPER_ARGS}
ENV MEMORY=2048M
ENTRYPOINT exec java -Xms${MEMORY} -Xmx${MEMORY} $PAPER_ARGS -Dcom.mojang.eula.agree=true @/opt/paper/server.args nogui

ARG PAPER_BUILD
LABEL com.robjdavey.minecraft.server.build="${PAPER_BUILD}"

ARG PAPER_VERSION
LABEL com.robjdavey.minecraft.server.version="${PAPER_VERSION}"

LABEL org.opencontainers.image.authors="Rob Davey <884913+RobJDavey@users.noreply.github.com>"
LABEL org.opencontainers.image.description="A Minecraft Server running PaperMC (https://papermc.io) for plugin support"
LABEL org.opencontainers.image.source="https://github.com/RobJDavey/minecraft-server"
LABEL org.opencontainers.image.title="RobJDavey's Minecraft Server"
LABEL org.opencontainers.image.url="https://github.com/RobJDavey/minecraft-server"
