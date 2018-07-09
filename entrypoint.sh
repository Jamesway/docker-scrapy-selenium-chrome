#!/bin/bash

# we "intercept" startproject commands and add
# - .gitignore
# - .sample-env
# - docker-compose.yml
# - a connection string to settings.py that pulls from .env

function copy_file {

  if [ -z "$1" ] || [ ! -f "$1" ]
  then
    echo "$0: invalid or missing source file $1, exiting"
    exit 1;
  fi

  if [ -z "$2" ] || [ ! -d "$2" ]
  then
    echo "$0: invalid or missing destination directory $2, exiting"
    exit 1;
  fi

  local file_name=$(basename "$1")

  if [ -f "${2}/${file_name}" ]
  then
    echo "${2}/${file_name} already exists, skipping"
    return 0
  fi

  cp "$1" "$2"
  echo "    copied ${file_name} to ${2}"
}


# jump to docker ENV APP_PATH
if [ -z "${APP_PATH}" ]
then
  echo "APP_PATH not set - are we running in a docker container?"
  exit 1
fi

if [ -z "${SRC_PATH}" ]
then
  echo "SRC_PATH not set - are we running in a docker container?"
  exit 1
fi

# pass the cli arguments to scrapy
if ! /usr/local/bin/scrapy "$@";
then
  /usr/local/bin/scrapy --help
  exit 0
fi

# we only want to change things if we're starting a project with a valid name
if [ -z "$1" ] || [ "$1" != "startproject" ] || [ -z "$2" ]
then
  # we only make changes when creating a project
  exit 0
fi

echo
echo "Starting post startproject customizations..."
echo

# vars
project_name=${2}
project_path="${APP_PATH}/${project_name}"
settings_path="${project_path}/${project_name}/settings.py"
cnxn_string="
# Added a connection string for mysql - values come from .env
from os import getenv
CONNECTION_STRING = \"{drivername}://{user}:{passwd}@{host}:{port}/{db_name}?charset=utf8\".format(
    drivername = \"mysql\",
    user = getenv(\"MYSQL_USER\"),
    passwd = getenv(\"MYSQL_PASSWORD\"),
    host = getenv(\"MYSQL_HOST\"),
    port = \"3306\",
    db_name = getenv(\"MYSQL_DATABASE\"),
)
"

# .gitignore
copy_file "${SRC_PATH}/.gitignore" "$project_path"

# .sample-env
copy_file "${SRC_PATH}/.sample-env" "$project_path"

# docker_compose
copy_file "${SRC_PATH}/docker-compose.yml" "$project_path"

# add the connection string support for .env to settings.py
if [ -f "${settings_path}" ]
then
  echo "${cnxn_string}" >>  "${settings_path}"
  echo "    added connection string section to settings.py"
else
  echo "can't find ${settings_path}, exiting"
  exit 1
fi

echo
echo "*****************************************************************************"
echo "IMPORTANT - copy .sample-env to .env and change the values to suit your needs"
echo "*****************************************************************************"
echo
