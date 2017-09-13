### Build wire-server-builder, wire-server-deps docker images locally

```bash
cd build/alpine && make
```

### Build brig:

From `/path/to/wire-server` (root directory of this repository)

```bash
SERVICE=brig; docker build -t local-$SERVICE -f build/alpine/Dockerfile --build-arg service=$SERVICE .
```

### Run brig as part of integration tests from containers

replace `web: LOG_LEVEL=Warn ./dist/brig` (...)

with `web: docker run --env LOG_LEVEL=Warn -v $(pwd):/tmp --workdir /tmp --network=host local-brig` (...)

in services/brig/Procfile

*Note: this will create a detached container; `docker container ls` and `docker container kill <id>` can be used to stop it.*