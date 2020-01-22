FROM ruby:2.6.5-alpine3.11

RUN \
apk add --no-cache --virtual build-dependencies --update \
    build-base \
    linux-headers \
    tzdata

ENV APP_ROOT /app

RUN mkdir ${APP_ROOT}

WORKDIR ${APP_ROOT}

ADD ./app/Gemfile Gemfile
ADD ./app/Gemfile.lock Gemfile.lock

RUN \
bundle install

ADD app ${APP_ROOT}

ENTRYPOINT ["/bin/sh", "-c","bundle exec rails s" ]