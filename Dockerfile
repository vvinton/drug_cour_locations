FROM omalab/devbox:0.8.9
MAINTAINER William Flanagan <wflanagan@audienti.com>

ENV APP_ROOT /var/app/maps
ENV DEBIAN_FRONTEND noninteractive

WORKDIR $APP_ROOT

EXPOSE 3000

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends mdbtools \
    && mkdir -p $APP_ROOT \
    && mkdir -p $APP_ROOT/log/ \
    && mkdir -p /bundle \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./Gemfile $APP_ROOT/Gemfile

RUN set -ex \
    && gem install bundler \
    && bundle install --jobs 20 --retry 5

COPY . $APP_ROOT

CMD bundle exec rails server -p 3000 -b 0.0.0.0
