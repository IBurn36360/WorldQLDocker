FROM openjdk:16.0.2-slim

LABEL Maintainer="The WorldQL Team"
LABEL Description="A plain client sever image for Mammoth, using the locally built version of the plugin"

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

# Copy in our config generating script and execute it
RUN mkdir -pv /srv/minecraft/plugins/WorldQLClient
RUN mkdir -pv /srv/mammoth/
RUN touch /srv/mammoth/config.yml

# Fetch the manual distro and the config/prep script
COPY ./Docker/ClientServer/WorldQLClient.jar /srv/mammoth/WorldQLClient.jar
COPY ./Docker/ClientServer/resolveArgumentsAndPrepConfig.sh /srv/mammoth/resolveArgumentsAndPrepConfig.sh

RUN chmod +x /srv/mammoth/resolveArgumentsAndPrepConfig.sh

WORKDIR /srv/minecraft

# Bind our port as the last step before we get going
EXPOSE 25565

# Alright, now that we have everything done, the start command is to just run the server
CMD /srv/mammoth/resolveArgumentsAndPrepConfig.sh && java -Xms${JAVA_MEMORY_MIN} -Xmx${JAVA_MEMORY_MAX} ${JAVA_ARGS} -jar paper.jar nogui
