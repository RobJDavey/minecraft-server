FROM openjdk:14-slim
WORKDIR /app
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
    && rm -rf /var/lib/apt/lists/* \
    && echo eula=true > eula.txt
ARG server_version
ENV server_version ${server_version:-1.16.1}
ADD https://papermc.io/api/v1/paper/${server_version}/latest/download ./paper.jar
EXPOSE 25565
HEALTHCHECK CMD [ "mcstatus", "localhost", "ping" ]
ENTRYPOINT [ "java", "-Xms10G", "-Xmx10G", "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-XX:G1NewSizePercent=30", "-XX:G1MaxNewSizePercent=40", "-XX:G1HeapRegionSize=8M", "-XX:G1ReservePercent=20", "-XX:G1HeapWastePercent=5", "-XX:G1MixedGCCountTarget=4", "-XX:InitiatingHeapOccupancyPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1RSetUpdatingPauseTimePercent=5", "-XX:SurvivorRatio=32", "-XX:+PerfDisableSharedMem", "-XX:MaxTenuringThreshold=1", "-jar", "paper.jar", "nogui" ]
