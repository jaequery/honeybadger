FROM ruby:2.2.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client
RUN apt-get install emacs24-nox -y

ENV TERM xterm-256color

#add init file
ADD Docker/init_container.sh /init_container.sh

#add APP
ADD . /app

#set default directory
WORKDIR /app
RUN bundle

EXPOSE 3000
