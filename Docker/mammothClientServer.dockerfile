FROM openjdk:16.0.2-slim

LABEL Maintainer="The WorldQL Team"
LABEL Description="A plain client server image for Mammoth"

# Set up WorldQL's base values
ENV WQL_LEAF_SQUARE_SIZE=16
ENV WQL_TREE_DEGREE=512
ENV WQL_NUM_LEVELS=2
ENV WQL_ROOTS_PER_TABLE=8

# Set up the base Java values
ENV JAVA_MEMORY_MIN="128M"
ENV JAVA_MEMORY_MAX="512M"
ENV JAVA_ARGS=""

RUN apt update
RUN apt install -y wget

# Time to build/download the client server and install the Mamoth plugin from the release
WORKDIR /srv/minecraft

RUN wget -O spigot.jar "https://download.getbukkit.org/spigot/spigot-1.17.1.jar"

# To actually run, we need a eula.txt and we need to download and install mammoth
RUN echo "eula=true" > eula.txt
RUN mkdir -pv ./plugins

WORKDIR /srv/minecraft/plugins

RUN wget https://github.com/WorldQL/mammoth/releases/download/v0.02-alpha/WorldQLClient-1.0-SNAPSHOT.jar

WORKDIR /srv/minecraft

# Bind our port as the last step before we get going
EXPOSE 25565

# Alright, now that we have everything done, the start command is to just run the server
CMD java -Xms${JAVA_MEMORY_MIN} -Xmx${JAVA_MEMORY_MAX} ${JAVA_ARGS} -jar spigot.jar nogui
# CMD sh