# Minecraft Forge Server with Docker

## Description
This image is designed to help you set up a Minecraft Forge server using Docker in just a few minutes. The image is available for multiple architectures, including linux/amd64, linux/arm64, and linux/arm/v7.

The image is based on Alpine Linux, and all the necessary server files are downloaded using a script.

[Link to my Docker image](https://hub.docker.com/r/tanke6003/minecraft-forge-server)

[Link to my GitHub repository](https://github.com/Tanke6003/minecraft-forge-server)

[Click here to tip me on PayPal!](https://paypal.me/Zoombeco)

## How to use this image

The recommended tag to use is 'latest,' as it represents the latest long-term support release.

### Simple Usage

It is advisable to use it with a volume to preserve your data physically. This allows you to easily manage the container - stop, destroy, and recreate it when necessary.

```
docker run --detach --name minecraft-forge-server --volume minecraft-server:/minecraft -p 25565:25565 tanke6003/minecraft-forge-server:latest
```

## Environment Variables

- `FORGE_VERSION`: Specifies the version of Minecraft Forge to download. Default value is **1.18-38.0.17**.

- `MAX_RAM`: Sets the maximum RAM for the server. Default value is **6G**.

- `MIN_RAM`: Sets the minimum RAM for the server. Default value is **4G**.

- `SEED`: Defines the world seed.

- `MOTD`: Sets the Message of the Day (MOTD) for the server.

- `SERVER_PORT`: Specifies the server port. Default value is **25565**.

- `RCON_PORT`: Specifies the RCON (Remote Console) port. Default value is **25575**.

- `RCON_PASSWORD`: Sets the RCON password.

- `DIFFICULTY`: Defines the server difficulty. Default is **1**.

- `GAMEMODE`: Sets the game mode. Default is **0**.

- `VIEW_DISTANCE`: Specifies the view distance. Default value is **8**.

- `SIMULATION_DISTANCE`: Defines the simulation distance. Default value is **8**.

- `MAX_PLAYERS`: Sets the maximum number of players allowed on the server. Default value is **10**.

- `WHITELIST`: Defines if the server uses a whitelist. Default is **FALSE**.

Make sure to adjust these environment variables to match your specific server requirements.

