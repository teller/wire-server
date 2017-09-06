# Requires docker >= 17.05 (requires support for multi-stage builds)
# Usage example:
#   SERVICE=galley docker build -t $SERVICE --build-args service=$SERVICE .

# Builder stage
FROM quay.io/wire/wire-server-cache:alpine as builder

ARG service
COPY . /src

RUN cd /src/services/${service} \
    && mkdir -p /dist \
    && stack install --pedantic --test --local-bin-path=/dist

# Minified stage
FROM quay.io/wire/alpine-deps:latest

ARG service
COPY --from=builder /dist/${service} /usr/local/bin/${service}

# ARGs are not available at runtime, create symlink at build time
# more info: https://stackoverflow.com/questions/40902445/using-variable-interpolation-in-string-in-docker
RUN ln -s /usr/local/bin/${service} /usr/local/bin/service
ENTRYPOINT ["/usr/local/bin/service"]
