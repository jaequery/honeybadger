#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
environment=$1
file=$2
parentdir="$(dirname "$dir")"
app=${parentdir##*/}

if [ -z "$2" ]
  then
    echo "missing argument"
    echo "ex) ./psql_import production something.psql"
    exit
fi

docker exec -it ${app}_db_1 psql --user=postgres honeybadger_$environment < $file

