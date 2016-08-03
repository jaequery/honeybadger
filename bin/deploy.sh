#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
dest=$1
dest="jae@x.hakberry.com"
#ssh $dest "cd ~/sites/$app/bin && ./psql_dump.sh production"
rsync --exclude="volumes" --exclude=".git" -avzr $parentdir $dest:~/sites/ && ssh $dest "cd ~/sites/$app && docker-compose stop && docker-compose -f docker-compose.live.yml up && docker-compose logs"
