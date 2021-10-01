#!/usr/bin/env bash

# Thank you Stack overflow for this bit of bash magic
# See: https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
SOURCE="${BASH_SOURCE[0]}"

while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    TARGET="$(readlink "$SOURCE")"
    if [[ $TARGET == /* ]]; then
        SOURCE="$TARGET"
    else
        DIR="$( dirname "$SOURCE" )"
        SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    fi
done

DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# Don't write the file if it exists
if [[ -f "${DIR}/.env" ]]
then
    echo "Cannot generate environment file as one exists.  Please delete the environment file and re-run this script to generate a new one."

    sleep 5s
else
    # Write the environment file where this script lives
    EnvironmentFile="${DIR}/.env"

    # We fetch the first 500 characters to be able to use valid ones with room to spare without exhausting the entropy in the system
    DBPass=$(head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~!$^*_-' | fold -w 20 | head -n 1)

    # Create the file
    touch "${EnvironmentFile}"

    echo "Generating environment file at [${EnvironmentFile}]"
    echo ""

    # The dev will be providing some info
    while true; do
        read -r -p "Please choose a name for the database: " DBName

        if (test -z "${DBName}") then
            echo "You MUST provide a database name!"
            echo ""
        else
            break;
        fi
    done

    while true; do
        read -r -p "Please choose a user that will connect to the database: " DBUser

        if (test -z "${DBUser}") then
            echo "You MUST provide a database user!"
            echo ""
        else
            break;
        fi
    done

    # Write the file
    {
        echo "WQL_DATABASE=${DBName}"
        echo "WQL_USER=${DBUser}"
        echo "WQL_PASSWORD=${DBPass}"
    } >> "${EnvironmentFile}"

    echo ""
    echo "Environment file has been written, please open [${EnvironmentFile}] to see development values.  You may now start Docker."

    read -r -p "Hit Enter to complete setup" tmp
fi
