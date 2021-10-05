# TODO: Since this is a bare-minimum control plane, we might bee able to get away with bare Linux instead of Alpine to make this image TINY
FROM alpine AS builder

WORKDIR /tmp

RUN apk add --update alpine-sdk postgresql-dev python3 libpq cmake
RUN wget https://github.com/jtv/libpqxx/archive/refs/tags/6.4.7.zip && unzip 6.4.7.zip

WORKDIR libpqxx-6.4.7

RUN ./configure --disable-documentation
RUN cmake src -Wno-dev
RUN make

#########################################
FROM alpine

LABEL Maintainer="The WorldQL Team"
LABEL Description="The main control plane image for Mammoth"

# Set the DB env vars
ENV WQL_LEAF_SQUARE_SIZE=16
ENV WQL_TREE_DEGREE=512
ENV WQL_NUM_LEVELS=2
ENV WQL_ROOTS_PER_TABLE=8

# Set our default values for some environment variables
ENV WQL_PORT=5432

RUN apk update
RUN apk upgrade
RUN apk --no-cache add libzmq libpq libc6-compat

# Fetch Mammoth's control plane binary from the release
RUN mkdir -pv /srv/mammoth-server/
RUN wget -O /srv/mammoth-server/WorldQLServer https://github.com/WorldQL/mammoth/releases/download/v0.01-alpha/WorldQLServer
RUN chmod +x /srv/mammoth-server/WorldQLServer

# Copy in our DSN building script, as it needs to be an environment variable for the binary
COPY ./Docker/ControlPlane/resolveEnvironmentAndRunControlPlane.sh /srv/mammoth-server/resolveEnvironmentAndRunControlPlane.sh
RUN chmod +x /srv/mammoth-server/resolveEnvironmentAndRunControlPlane.sh

RUN chown -Rv nobody.nobody /srv/mammoth-server

# We need to alter the run directory permissions for Supervisor
RUN chown -R nobody.nobody /run

# Lastly, copy in the libraries from the builder
COPY --from=builder /tmp/libpqxx-6.4.7/libpqxx.so /usr/lib/libpqxx-6.4.so

# Run as nobody since we don't want Mammoth to be a security hazard here
USER nobody

EXPOSE 5555
EXPOSE 5554

# We don't need to run anything fancy here, so in preparation for a barebones image, just terminate the container if the process dies
CMD /srv/mammoth-server/resolveEnvironmentAndRunControlPlane.sh
