FROM omalab/devbox:0.7.16
MAINTAINER William Flanagan <wflanagan@audienti.com>

ENV OMA_ROOT /var/app/maps
ENV DEBIAN_FRONTEND noninteractive

ARG developer_token
WORKDIR $OMA_ROOT

EXPOSE 3000 3001 3002 3003 3004 3005 9292 9293

RUN set -ex \
    && mkdir -p $OMA_ROOT \
    && mkdir -p $OMA_ROOT/log/ \
    && mkdir -p /bundle

ENV BUNDLE_PATH /bundle

COPY ./Gemfile $OMA_ROOT/Gemfile

RUN set -ex \
    && gem install bundler \
    && bundle install --jobs 20 --retry 5

COPY . $OMA_ROOT

CMD bundle exec rails server -p 3000
