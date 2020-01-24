FROM ruby:2.6.5-alpine3.10

ENV ROOT="/myapp"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR ${ROOT}

RUN apk update \
  && apk upgrade \
  && apk add --no-cache \
    gcc \
    g++ \
    libc-dev \
    libxml2-dev \
    linux-headers \
    make \
    nodejs \
    postgresql \
    postgresql-dev \
    sqlite-dev \
    tzdata \
    yarn \
  && apk add --no-cache --virtual build-packages \
    build-base \
    curl-dev

COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN bundle install
RUN apk del build-packages

COPY . ${ROOT}

RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
  && chmod +x mkcert \
  && ./mkcert -install \
  && ./mkcert localhost \
  && rm -rf ./mkcert

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ash -c "bundle exec rails s"