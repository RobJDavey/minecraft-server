# Minecraft Server

## Description

A [Minecraft Server](https://www.minecraft.net/download/server/) docker container, running [PaperMC](https://papermc.io) to provide plugin support.

- Uses Paper's recommended JVM flags for each Minecraft version
- Saves the world and shuts down cleanly on `docker stop`
- Small JRE-based image, with Ubuntu and Alpine variants
- Runs as a non-root user (uid/gid `25565`)

## Tags

| Tag | Description |
| --- | --- |
| `latest`, `<version>` (e.g. `26.3`) | Ubuntu-based image |
| `latest-alpine`, `<version>-alpine` (e.g. `26.3-alpine`) | Alpine-based image, smaller |

Each tag uses the latest stable Paper build for that Minecraft version.

## How to use this image

Using this image means you accept the [Minecraft EULA](https://aka.ms/MinecraftEULA).

Start a new instance, keeping the server data in a volume:

``` shell
docker run -p 25565:25565 -d \
    -v minecraft-data:/minecraft \
    robjdavey/minecraft-server
```

Everything the server writes lives in `/minecraft`: worlds, `server.properties`, `ops.json`, the whitelist, plugins, Paper's `config/` folder and logs. Keep it in a volume so it survives the container being recreated or upgraded.

### Docker Compose

``` shell
docker compose up -d
```

The image version is set by `SERVER_VERSION` in `.env`. It's pinned rather than set to `latest`, because a world can't be downgraded once a newer version has opened it, so upgrades should be done on purpose.

### Configuration

| Environment variable | Default | Description |
| --- | --- | --- |
| `MEMORY` | `2048M` | Java heap size (used for both `-Xms` and `-Xmx`) |
| `PAPER_ARGS` | Paper's recommended flags | Extra JVM flags |
| `TZ` | `UTC` | Time zone for log timestamps |

To change server settings, edit the files in the data volume and restart the server.

### Console

The container runs with a TTY and stdin open (`-it`, or `tty` and `stdin_open` in compose), so you can type server commands:

``` shell
docker attach <container>
```

Detach again with **Ctrl-P Ctrl-Q**. Pressing Ctrl-C stops the server.

## Building

``` shell
./build          # Ubuntu-based image
./build alpine   # Alpine-based image
```

The build needs `podman`, `curl` and `jq`. It looks up the newest Minecraft version with a stable Paper build, builds the image, and checks the jar against Paper's published checksum. Before pushing, it smoke-tests the image: it starts the server with no network and checks that it starts and shuts down cleanly.
