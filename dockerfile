FROM debian:stable-20231009-slim
RUN apt-get update && apt-get install -y wget screen default-jre
ENV FORGE_VERSION=1.18-38.0.17 \
    MAX_RAM="6G" \
    MIN_RAM="4G" \
    SEED="" \
    MOTD="Minecraft Server in Docker" \
    SERVER_PORT=25565 \
    RCON_PORT=25575 \
    RCON_PASSWORD="DockerServer" \
    DIFFICULTY=1 \
    GAMEMODE=0 \
    VIEW_DISTANCE=8 \
    SIMULATION_DISTANCE=8 \
    MAX_PLAYERS=10 \
    WHITELIST=FALSE 
EXPOSE ${SERVER_PORT}/tcp ${RCON_PORT}/tcp
RUN mkdir /minecraft && chmod -R 777 /minecraft
RUN echo  '#!/bin/sh' > /start.sh && \
    echo  'configServer() {' >> /start.sh && \
    echo  '    conf_file="server.properties"' >> /start.sh && \
    echo  '    if [ -n "${MOTD}" ]; then' >> /start.sh && \
    echo  '        echo "motd=${MOTD}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${SEED}" ]; then' >> /start.sh && \
    echo  '        echo "level-seed=${SEED}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${SERVER_PORT}" ]; then' >> /start.sh && \
    echo  '        echo "server-port=${SERVER_PORT}" >> $conf_file' >> /start.sh && \
    echo  '        echo "query.port=${SERVER_PORT}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${RCON_PORT}" ]; then' >> /start.sh && \
    echo  '        echo "rcon.port=${RCON_PORT}" >> $conf_file' >> /start.sh && \
    echo  '        echo "enable-rcon=true" >> $conf_file' >> /start.sh && \
    echo  '        if [ -n "${RCON_PASSWORD}" ]; then' >> /start.sh && \
    echo  '            echo "rcon.password=${RCON_PASSWORD}" >> $conf_file' >> /start.sh && \
    echo  '        fi' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${DIFFICULTY}" ]; then' >> /start.sh && \
    echo  '        echo "difficulty=${DIFFICULTY}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${GAMEMODE}" ]; then' >> /start.sh && \
    echo  '        echo "gamemode=${GAMEMODE}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${VIEW_DISTANCE}" ]; then' >> /start.sh && \
    echo  '        echo "view-distance=${VIEW_DISTANCE}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${SIMULATION_DISTANCE}" ]; then' >> /start.sh && \
    echo  '        echo "simulation-distance=${SIMULATION_DISTANCE}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${MAX_PLAYERS}" ]; then' >> /start.sh && \
    echo  '        echo "max-players=${MAX_PLAYERS}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    if [ -n "${WHITELIST}" ]; then' >> /start.sh && \
    echo  '        echo "white-list=${WHITELIST}" >> $conf_file' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '}' >> /start.sh && \
    echo  'execServer() {' >> /start.sh && \
    echo  '    echo "Execute Minecraft Forge Server..."' >> /start.sh && \
    echo  '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM}" > user_jvm_args.txt' >> /start.sh && \
    echo  '    if [ -f run.sh ]; then' >> /start.sh && \
    echo  '       sh run.sh ' >> /start.sh && \
    echo  '    else' >> /start.sh && \
    echo  '       java $(< user_jvm_args.txt) -jar minecraft_server.*.jar nogui ' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '}' >> /start.sh && \
    echo  'if ! command -v java &> /dev/null; then' >> /start.sh && \
    echo  '   echo "Install OpenJDK 17..."' >> /start.sh && \
    echo  '   apk add --no-cache openjdk11' >> /start.sh && \
    echo  'fi' >> /start.sh && \
    echo  'cd /' >> /start.sh && \
    echo  'cd minecraft' >> /start.sh && \
    echo  'if ([ -f run.sh ] || [ -n "$(find . -name "minecraft-server.*.jar")" ]) && [ -d world ]; then' >> /start.sh && \
    echo  '    echo "The server and world already exist..."' >> /start.sh && \
    echo  '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM}" > user_jvm_args.txt' >> /start.sh && \
    echo  '    configServer' >> /start.sh && \
    echo  '    execServer' >> /start.sh && \
    echo  'else' >> /start.sh && \
    echo  '    if [ ! -f forge-installer.jar ]; then' >> /start.sh && \
    echo  '        echo "Download Minecraft Forge Installer V${FORGE_VERSION}..."' >> /start.sh && \
    echo  '        wget -O forge-installer.jar "https://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar"' >> /start.sh && \
    echo  '    fi' >> /start.sh && \
    echo  '    echo "Execute Minecraft Forge Installer..."' >> /start.sh && \
    echo  '    java -jar forge-installer.jar --installServer' >> /start.sh && \
    echo  '    rm forge-installer.jar' >> /start.sh && \
    echo  '    echo "Execute Minecraft Forge Server to create files..."' >> /start.sh && \
    echo  '    execServer' >> /start.sh && \
    echo  '    echo "Load World..."' >> /start.sh && \
    echo  '    echo "eula=true" > eula.txt' >> /start.sh && \
    echo  '    configServer' >> /start.sh && \
    echo  '    execServer' >> /start.sh && \
    echo  'fi' >> /start.sh
RUN chmod +x /start.sh 
CMD ["/bin/sh","/start.sh"]