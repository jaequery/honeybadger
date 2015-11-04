#!/bin/bash
padrino rake db:reset
padrino rake db:seed
padrino s
