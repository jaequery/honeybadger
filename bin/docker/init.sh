#!/bin/bash

bundle

if [ ! -f /tmp/initialized ]
then
rake sq:create
rake sq:migrate
rake db:seed
touch /tmp/initialized
fi

padrino s -h 0.0.0.0
