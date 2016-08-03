#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
environment=$1
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
app=${app/./}
timestamp=$(date +"%m%d%y_%H%M%S")

echo $environment

if [ -z "$1" ]
  then
    echo "missing argument"
    echo "ex) ./psql_dump production (or development)"
    exit
fi

file="../sql/markett_"$environment"_"$timestamp".psql"
docker exec -it markett_db_1 pg_dump --user=postgres honeybadger_$environment > $file

