#!/bin/bash
bundle
padrino rake db:reset
padrino rake db:migrate
padrino rake db:seed
#bundle exec passenger start
padrino s -h 0.0.0.0
