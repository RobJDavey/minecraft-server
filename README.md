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
| `latest`, `<version>` (e.g. `26.3`) | Ubuntu-based image, latest stable Paper build |
| `<version>-<build>` (e.g. `26.3-222`) | Ubuntu-based image, a specific Paper build that never changes |
| `latest-alpine`, `<version>-alpine` | Alpine-based image, smaller |
| `<version>-<build>-alpine` | Alpine-based image, a specific Paper build |

Images are published for every Minecraft version from 1.18 onwards that has a stable Paper build, for both `linux/amd64` and `linux/arm64`. Alpine images start at 1.20.5, because older Java versions have no arm64 Alpine base image.

Pin a `<version>-<build>` tag to stay on an exact Paper build, or to roll back if a new build causes problems.

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
./build                 # Ubuntu-based image for the newest Minecraft version
./build alpine          # Alpine-based image for the newest Minecraft version
./build full 1.20.6     # Ubuntu-based image for a specific version
./build plan            # List the images whose Paper build isn't published yet
```

The build needs `podman`, `curl` and `jq`. It checks the jar against Paper's published checksum. Before pushing, it smoke-tests the image for each platform: it starts the server with no network and checks that it starts and shuts down cleanly.

GitHub Actions publishes the images:

- **Every day:** builds only the images whose `<version>-<build>` tag isn't on Docker Hub yet. A run that finds nothing new finishes in seconds.
- **On the 1st of each month:** rebuilds everything on fresh base images.
- **On changes to the `Dockerfile`, `build` or the workflow:** rebuilds everything.
- **Manually:** use **Run workflow** in the Actions tab, optionally with **Rebuild every version** ticked.
