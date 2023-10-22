FROM openjdk:18-jdk-alpine3.15
#FROM alpine:3.18.4
#RUN apk update && apk add --no-cache openjdk16-jdk
RUN mkdir -p /minecraft
WORKDIR /minecraft
ENV FORGE_VERSION=1.18-38.0.17
ENV MAX_RAM="4G"
ENV MIN_RAM="2G"
ENV MAX_CORES="4"
EXPOSE 25565
RUN echo -e '#!/bin/sh' > /start.sh && \
    echo -e 'if [ -f /minecraft/run.sh ] && [ -d /minecraft/world ]; then' >> /start.sh && \
    echo -e '    echo "El servidor y el mapa ya existen..."' >> /start.sh && \
    echo -e '    ./minecraft/run.sh' >> /start.sh && \
    echo -e 'else' >> /start.sh && \
    echo -e '    if [ ! -f /minecraft/forge-installer.jar ]; then' >> /start.sh && \
    echo -e '        echo "Descargando Minecraft Forge Installer..."' >> /start.sh && \
    echo -e "        wget -O /minecraft/forge-installer.jar https://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar" >> /start.sh && \
    echo -e '    fi' >> /start.sh && \
    echo -e '    echo "Ejecutando el instalador de Minecraft Forge..."' >> /start.sh && \
    echo -e '    java -jar /minecraft/forge-installer.jar --installServer' >> /start.sh && \
    echo -e '    rm /minecraft/forge-installer.jar' >> /start.sh && \
    echo -e '    echo "Ejecutando el servidor de Minecraft Forge..."' >> /start.sh && \
    echo -e '    echo "-Xmx${MAX_RAM} -Xms${MIN_RAM} -XX:ParallelGCThreads=${MAX_CORES}" > /minecraft/user_jvm_args.txt' >> /start.sh && \  
    echo -e '    sh /minecraft/run.sh' >> /start.sh && \
    echo -e '    echo "Creando un nuevo mundo..."' >> /start.sh && \
    echo -e '    echo "eula=true" > /minecraft/eula.txt' >> /start.sh && \
    echo -e '    sh /minecraft/run.sh' >> /start.sh && \
    echo -e 'fi' >> /start.sh
RUN chmod +x /start.sh
CMD ["/bin/sh","/start.sh"]
