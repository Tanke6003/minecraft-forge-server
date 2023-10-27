FROM alpine:3.15
ENV FORGE_VERSION=1.18-38.0.17 \
    MAX_RAM="6G" \
    MIN_RAM="4G" \
    SEED="" \
    MOTD="&c&lA &a&nMinecraft &b&nServer &c&lPowered by &e&lDocker&r" \
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
RUN echo -e '#!/bin/sh' > /start.sh && \
    echo -e 'configServer() {' >> /start.sh && \
    echo -e '    if [ -n "${MOTD}" ]; then' >> /start.sh && \
    echo -e '        echo "motd=${MOTD}" > server.properties'>> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${SEED}" ]; then' >> /start.sh && \
    echo -e '        echo "level-seed=${SEED}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${SERVER_PORT}" ]; then' >> /start.sh && \
    echo -e '        echo "server-port=${SERVER_PORT}" > server.properties' >> /start.sh && \
    echo -e '        echo "query.port=${SERVER_PORT}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${RCON_PORT}" ]; then' >> /start.sh && \
    echo -e '        echo "rcon.port=${RCON_PORT}" > server.properties' >> /start.sh && \
    echo -e '        echo "enable-rcon=true" > server.properties' >> /start.sh && \
    echo -e '        if [ -n "${RCON_PASSWORD}" ]; then' >> /start.sh && \
    echo -e '            echo "rcon.password=${RCON_PASSWORD}" > server.properties' >> /start.sh && \
    echo -e '        fi' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${DIFFICULTY}" ]; then' >> /start.sh && \
    echo -e '        echo "difficulty=${DIFFICULTY}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${GAMEMODE}" ]; then' >> /start.sh && \
    echo -e '        echo "gamemode=${GAMEMODE}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${VIEW_DISTANCE}" ]; then' >> /start.sh && \
    echo -e '        echo "view-distance=${VIEW_DISTANCE}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${SIMULATION_DISTANCE}" ]; then' >> /start.sh && \
    echo -e '        echo "simulation-distance=${SIMULATION_DISTANCE}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${MAX_PLAYERS}" ]; then' >> /start.sh && \
    echo -e '        echo "max-players=${MAX_PLAYERS}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    if [ -n "${WHITELIST}" ]; then' >> /start.sh && \
    echo -e '        echo "white-list=${WHITELIST}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '}' >> /start.sh && \
    echo -e 'echo "Install OpenJDK 17..."' >> /start.sh && \
    echo -e 'apk add --no-cache openjdk17' >> /start.sh && \
    echo -e 'cd /' >> /start.sh && \
    echo -e 'if [ ! -d minecraft ]; then' >> /start.sh && \
    echo -e '    mkdir minecraft' >> /start.sh && \
    echo -e 'fi' >> /start.sh && \
    echo -e 'cd minecraft' >> /start.sh && \
    echo -e 'if [ -f run.sh ] && [ -d world ]; then' >> /start.sh && \
    echo -e '    echo "The server and world already exist..."' >> /start.sh && \
    echo -e '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM}" > user_jvm_args.txt' >> /start.sh && \
    echo -e '    configServer' >> /start.sh && \
    echo -e '    sh run.sh ' >> /start.sh && \
    echo -e 'else' >> /start.sh && \
    echo -e '    if [ ! -f forge-installer.jar ]; then' >> /start.sh && \
    echo -e '        echo "Download Minecraft Forge Installer..."' >> /start.sh && \
    echo -e "        wget -O forge-installer.jar https://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar" >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    echo "Execute Minecraft Forge Installer..."' >> /start.sh && \
    echo -e '    java -jar forge-installer.jar --installServer' >> /start.sh && \
    echo -e '    rm forge-installer.jar' >> /start.sh && \
#    echo -e '    rm forge-installer.jar.log' >> /start.sh && \
    echo -e '    echo "Execute Minecraft Forge Server to create files..."' >> /start.sh && \
    echo -e '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM}" > user_jvm_args.txt' >> /start.sh && \
    echo -e '    sh run.sh ' >> /start.sh && \
    echo -e '    echo "Load World..."' >> /start.sh && \
    echo -e '    echo "eula=true" > eula.txt' >> /start.sh && \
    echo -e '    configServer' >> /start.sh && \
    echo -e '    sh run.sh ' >> /start.sh && \
    echo -e 'fi' >> /start.sh
RUN chmod +x /start.sh
CMD ["/bin/sh","/start.sh"]