# Honeybadger - A hackathon starter built for simplicity

[![Join the chat at https://gitter.im/jaequery/honeybadger](https://badges.gitter.im/jaequery/honeybadger.svg)](https://gitter.im/jaequery/honeybadger?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![ComposeUp](https://img.shields.io/badge/Compose-Ready-brightgreen.svg)](https://composeup.com/honeybadger)

Creating Honeybadger, an opensource Ruby/Sinatra based CMS that helps you kickstart projects. It provides a boiler-plate code with the goal of being an extremely simple CMS alternative to Wordpress, Drupa, and etc.

I love simplicity because to me less code, less methods, and the less syntaxes the better.

The code is freely available on https://github.com/jaequery/honeybadger for you to check out.

### Setup is easy with Docker ###

1. Clone the codebase

```
git clone git@github.com:jaequery/honeybadger.git
```

2. Update VIRTUAL_HOST property with your desired hostname (eg: honeybadger.dev) on docker-compose.yml

3. Run docker compose

```
cd honeybadger
docker-compose up
```
