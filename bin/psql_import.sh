#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
file=$1
environment=$2
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
timestamp=$(date +"%m%d%y_%H%M%S")

echo $environment

if [ -z "$2" ]
  then
    echo "missing argument"
    echo "ex) ./psql_import something.psql production"
    exit
fi

docker exec -it markett_db_1 psql --user=postgres honeybadger_$environment < $file

