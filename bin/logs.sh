#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
app=${app/./}
docker exec -it ${app}_app_1 tail -f /app/log/passenger.3000.log
