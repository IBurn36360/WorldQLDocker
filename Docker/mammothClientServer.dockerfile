FROM openjdk:16.0.2-slim

LABEL Maintainer="The WorldQL Team"
LABEL Description="A client sever image for Mammoth"

# Set up the base Java values
ENV JAVA_MEMORY_MIN="128M"
ENV JAVA_MEMORY_MAX="512M"
ENV JAVA_ARGS=""

RUN apt update
RUN apt install -y wget

COPY ./Docker/ClientServer/resolveArgumentsAndPrepConfig.sh /srv/mammoth/resolveArgumentsAndPrepConfig.sh
COPY ./Docker/ClientServer/plugins /srv/mammoth/plugins

RUN chmod +x /srv/mammoth/resolveArgumentsAndPrepConfig.sh

WORKDIR /srv/minecraft

# Bind our port as the last step before we get going
EXPOSE 25565

# Alright, now that we have everything done, the start command is to just run the server
CMD /srv/mammoth/resolveArgumentsAndPrepConfig.sh && java -Xms${JAVA_MEMORY_MIN} -Xmx${JAVA_MEMORY_MAX} ${JAVA_ARGS} -jar paper.jar nogui
