FROM bitwalker/alpine-elixir:1.6.1 as builder

ENV HOME /opt/app/
ENV TERM xterm
ENV MIX_ENV prod

RUN \
  apk add --update \
  musl=1.1.18-r3 git make g++ && \
  rm -rf /var/cache/apk/*

WORKDIR $HOME

# Cache elixir deps
RUN mkdir config
COPY config/* config/
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .

RUN mix release --env=prod --verbose

# Production image
FROM bitwalker/alpine-erlang:20.1.3
EXPOSE 4000

ENV PORT 4000
ENV REPLACE_OS_VARS true
ENV SHELL /bin/sh
ENV APP_NAME voyager
ENV APP_VERSION "0.0.1"

RUN apk update && \
  apk --no-cache --update add libgcc libstdc++ imagemagick && \
  rm -rf /var/cache/apk/*

COPY --from=builder /opt/app/_build/prod/rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.tar.gz ./$APP_NAME.tar.gz
RUN tar -xzf ./$APP_NAME.tar.gz
RUN chown -R default .

USER default

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["init"]
