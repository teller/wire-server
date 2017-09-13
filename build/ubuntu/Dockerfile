# Requires docker >= 17.05 (requires support for multi-stage builds)
# Usage example:
#   (from wire-server root directory)
#   SERVICE=brig; docker build -f build/ubuntu/Dockerfile -t $SERVICE --build-arg service=$SERVICE .

# Builder stage
FROM quay.io/wire/wire-server-cache:ubuntu as builder

ARG service
COPY . /src

RUN cd /src/services/${service} && make

# Minified stage
FROM quay.io/wire/wire-server-deps:ubuntu

ARG service
COPY --from=builder /dist/${service} /usr/local/bin/${service}

# ARGs are not available at runtime, create symlink at build time
# more info: https://stackoverflow.com/questions/40902445/using-variable-interpolation-in-string-in-docker
RUN ln -s /usr/local/bin/${service} /usr/local/bin/service
ENTRYPOINT ["/usr/local/bin/service"]
