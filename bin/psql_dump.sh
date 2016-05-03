#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
environment=$1
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
timestamp=$(date +"%m%d%y_%H%M%S")

if [ -z "$1" ]
  then
    echo "missing argument"
    echo "ex) ./psql_dump production (or development)"
    exit
fi

if [ -z "$2" ]
  then
    file="db_"$environment"_"$timestamp".psql"
  else
    file=$2
fi

docker exec -it ${app}_db_1 pg_dump --user=postgres honeybadger_$environment > $file

