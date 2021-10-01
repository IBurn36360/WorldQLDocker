FROM openjdk:16.0.2-slim

LABEL Maintainer="The WorldQL Team"
LABEL Description="A plain client sever image for Mammoth"

# Set up the base Java values
ENV JAVA_MEMORY_MIN="128M"
ENV JAVA_MEMORY_MAX="512M"
ENV JAVA_ARGS=""

RUN apt update
RUN apt install -y wget

# Time to build/download the client server and install the Mamoth plugin from the release
WORKDIR /srv/minecraft

RUN wget -O paper.jar "https://papermc.io/api/v2/projects/paper/versions/1.17.1/builds/281/downloads/paper-1.17.1-281.jar"

# To actually run, we need a eula.txt and we need to download and install mammoth
RUN echo "eula=true" > eula.txt
RUN mkdir -pv ./plugins

WORKDIR /srv/minecraft/plugins

# Fetch the current WorldQL Distro
RUN wget https://github.com/WorldQL/mammoth/releases/download/v0.02-alpha/WorldQLClient-1.0-SNAPSHOT.jar

# Copy in our config generating script and execute it
RUN mkdir -pv /srv/minecraft/plugins/WorldQLClient

WORKDIR /srv/minecraft/plugins/WorldQLClient

COPY ./Docker/ClientServer/resolveArgumentsAndPrepConfig.sh resolveArgumentsAndPrepConfig.sh

RUN chmod +x resolveArgumentsAndPrepConfig.sh

WORKDIR /srv/minecraft

# Bind our port as the last step before we get going
EXPOSE 25565

# Alright, now that we have everything done, the start command is to just run the server
CMD /srv/minecraft/plugins/WorldQLClient/resolveArgumentsAndPrepConfig.sh && java -Xms${JAVA_MEMORY_MIN} -Xmx${JAVA_MEMORY_MAX} ${JAVA_ARGS} -jar paper.jar nogui


