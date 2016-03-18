#!/bin/bash
dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
parentdir="$(dirname "$parentdir")"
app=${parentdir##*/}
docker exec -it ${app}_app_1 $1
