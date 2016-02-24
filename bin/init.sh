#!/bin/bash
./exec.sh 'bundle'
./exec.sh 'padrino rake db:reset'
./exec.sh 'padrino rake db:migrate'
./exec.sh 'padrino rake db:seed'
./exec.sh 'padrino start'
