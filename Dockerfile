FROM alpine:edge

# system deps
RUN apk add gleam rebar3

# download dependencies
WORKDIR /srv/unlikely
COPY gleam.toml manifest.toml .
RUN gleam deps download

# copy wordlist into container as well
COPY resources/ resources/

# build app itself
COPY src/ src/
RUN gleam build -t erlang


# run service on container start
CMD ["gleam", "run"]

EXPOSE 4000
