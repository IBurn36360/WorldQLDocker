#!/usr/bin/env sh

# Looks at the passed in environment variable and maybe resolve a separate environment variable at runtime
#
# @param string $envString
#
# @return string maybe resolved environment variable
maybe_resolve_env_from_env () {
  case "$1" in
      # Check for a sub resolution
      "__RESOLVE::"*)
        SUB=$(echo "$1" | sed -e "s/__RESOLVE:://g")
        # Time to recur in!
        maybe_resolve_env_from_env "${SUB}" ;;

      # DEFAULT: Just return the environment variable if it matched nothing above
      *)
        printenv -- "$1" ;;
    esac
}

ConfigFile="/srv/mammoth/config.yml"

# Delete any config we might already have, as we will be treating it as bad during a rebuild
touch "${ConfigFile}"
truncate -s 0 "${ConfigFile}"

echo "Generating WorldQLConfig file at container runtime!"

echo "# WorldQL Connection Details" >> "${ConfigFile}"
echo "# Generated by Docker build scripts on [$(date)]" >> "${ConfigFile}"

# Go over our primary variables that will be used during the construction of the config file and assign defaults if values are missing
if [ -n "${WQL_CONTROL_PLANE_HOST}" ] || [ -n "${WQL_CONTROL_PLANE_HANDSHAKE_PORT}" ] || [ -n "${WQL_CONTROL_PLANE_PUSH_PORT}" ]; then
  # Make sure we write the config header
  echo "worldql:" >> "${ConfigFile}"

  # And write only what has a value
  if [ -n "${WQL_CONTROL_PLANE_HOST}" ]; then
    echo "  host: \"$(maybe_resolve_env_from_env "WQL_CONTROL_PLANE_HOST")\"" >> "${ConfigFile}"
  fi

  if [ -n "${WQL_CONTROL_PLANE_HANDSHAKE_PORT}" ]; then
    echo "  handshake-port: \"$(maybe_resolve_env_from_env "WQL_CONTROL_PLANE_HANDSHAKE_PORT")\"" >> "${ConfigFile}"
  fi

  if [ -n "${WQL_CONTROL_PLANE_PUSH_PORT}" ]; then
    echo "  push-port: \"$(maybe_resolve_env_from_env "WQL_CONTROL_PLANE_PUSH_PORT")\"" >> "${ConfigFile}"
  fi
fi

if [ -n "${WQL_SELF_IDENT_HOST}" ]; then
  if [ -n "${WQL_CONTROL_PLANE_HOST}" ] || [ -n "${WQL_CONTROL_PLANE_HANDSHAKE_PORT}" ] || [ -n "${WQL_CONTROL_PLANE_PUSH_PORT}" ]; then
    # Put a newline in here
    echo "" >> "${ConfigFile}"
  fi

  echo "# Client (self) Hostname" >> "${ConfigFile}"
  echo "host: \"$(maybe_resolve_env_from_env "WQL_SELF_IDENT_HOST")\"" >> "${ConfigFile}"
fi

# Now what our file has been written, time to check for, maybe hardlink the plugin and the config from the "local" disk
if [ ! -f /srv/minecraft/plugins/WorldQLClient.jar ]; then
  echo "Creating Symbolic link for the plugin!"

  mkdir -pv /srv/minecraft/plugins
  ln -s /srv/mammoth/WorldQLClient.jar /srv/minecraft/plugins/WorldQLClient.jar
fi

if [ ! -f /srv/minecraft/plugins/WorldQLClient/config.yml ]; then
  echo "Creating Symbolic link for the plugin config!"

  mkdir -pv /srv/minecraft/plugins/WorldQLClient/
  ln -s /srv/mammoth/config.yml /srv/minecraft/plugins/WorldQLClient/config.yml
fi

# Echo out the config file so that the build log has a record of it
echo "WorldQL configuration file generates with the following content:"
echo "----------------------------"
cat ${ConfigFile}
echo "----------------------------"
