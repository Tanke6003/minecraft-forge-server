#FROM alpine:3.18
FROM openjdk:18-jdk-alpine3.15
#RUN apk update && apk add openjdk17-17.0.9_p8-r0.apk  
RUN mkdir /minecraft
#WORKDIR /minecraft
ENV FORGE_VERSION=1.18-38.0.17 \
    MAX_RAM="6G" \
    MIN_RAM="4G" \
    SEED=""
EXPOSE 25565
RUN echo -e '#!/bin/sh' > /start.sh && \
    echo -e 'cd minecraft' >> /start.sh && \
    echo -e 'if [ -f run.sh ] && [ -d world ]; then' >> /start.sh && \
    echo -e '    echo "El servidor y el mapa ya existen..."' >> /start.sh && \
    echo -e '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM} " > user_jvm_args.txt' >> /start.sh && \  
    echo -e '    sh run.sh ' >> /start.sh && \
    echo -e 'else' >> /start.sh && \
    echo -e '    if [ ! -f forge-installer.jar ]; then' >> /start.sh && \
    echo -e '        echo "Descargando Minecraft Forge Installer..."' >> /start.sh && \
    echo -e "        wget -O forge-installer.jar https://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar" >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    echo "Ejecutando el instalador de Minecraft Forge..."' >> /start.sh && \
    echo -e '    java -jar forge-installer.jar --installServer' >> /start.sh && \
    echo -e '    rm forge-installer.jar' >> /start.sh && \
    echo -e '    rm forge-installer.jar.log' >> /start.sh && \
    echo -e '    echo "Ejecutando el servidor de Minecraft Forge..."' >> /start.sh && \
    echo -e '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM}" > user_jvm_args.txt' >> /start.sh && \  
    echo -e '    sh run.sh ' >> /start.sh && \
    echo -e '    echo "Creando un nuevo mundo..."' >> /start.sh && \
    echo -e '    echo "eula=true" > eula.txt' >> /start.sh && \
    echo -e '    if [ -n "${SEED}" ]; then' >> /start.sh && \  
    echo -e '        echo "level-seed=${SEED}" > server.properties' >> /start.sh && \
    echo -e '    fi' >> /start.sh && \  
    echo -e '    sh run.sh ' >> /start.sh && \
    echo -e 'fi' >> /start.sh
RUN chmod +x /start.sh
CMD ["/bin/sh","/start.sh"]
