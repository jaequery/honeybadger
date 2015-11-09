#!/bin/bash
padrino rake db:reset
padrino rake db:seed
passenger start
