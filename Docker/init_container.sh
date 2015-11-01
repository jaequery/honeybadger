#!/bin/bash
bundle
padrino rake db:reset
padrino rake db:migrate
padrino rake db:seed
padrino s -h 0.0.0.0
