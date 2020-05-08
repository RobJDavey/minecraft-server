# Minecraft Server

## Description

A [Minecraft Server](https://www.minecraft.net/download/server/) docker container, running [PaperMC](https://papermc.io) to provide plugin support.

## How to use this image

Start a new instance:

``` shell
docker run -p 25565:25565 -d \
    robjdavey/minecraft-server
```

Start an instance with the worlds stored in local folders:

``` shell
docker run -p 25565:25565 -d \
    -v /some/folder/world:/app/world \
    -v /some/folder/world_nether:/app/world_nether \
    -v /some/folder/world_the_end:/app/world_the_end \
    robjdavey/minecraft-server
```
