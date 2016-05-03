#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
./stop.sh
docker exec -it ${app}_app_1 padrino rake db:reset
./start.sh