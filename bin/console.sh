#!/bin/bash
dir=`pwd`
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
docker exec -it ${app}_app_1 padrino console