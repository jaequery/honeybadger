#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
docker exec -it ${app}_app_1 psql --host=honeybadger-postgres --user=postgres
