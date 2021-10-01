#!/usr/bin/env sh

echo "Generating postgres DSN at runtime!"

export WQL_POSTGRES_CONNECTION_STRING="postgresql://${WQL_USER}:${WQL_PASSWORD}@${WQL_HOST}?port=${WQL_PORT}&dbname=${WQL_DB}"

echo "DSN generated as [${WQL_POSTGRES_CONNECTION_STRING}]"

echo "Sleeping for 10 seconds to allow database to progress to accepting connections..."

# The control plane can be a little too fast sometimes, so wait a few seconds so the DB can come up
sleep 10

echo "Running Mammoth Control Plane"

# And run with the server arg
/srv/mammoth-server/WorldQLServer -server
