
## [JADX](https://github.com/samsheff/docker-jadx)


## Jadx Alias

```sh
jadx() {
      # JADX
      # https://github.com/samsheff/docker-jadx
      # docker build --rm --force-rm -t "s2e/jadx" .
      local NAME="jadx"
      local SUFFIX="jadx"
        docker_del_stopped "${NAME}"
        docker run \
              -v /tmp/.X11-unix:/tmp/.X11-unix \
               -e "DISPLAY=unix${DISPLAY}" \
               --rm \
               -it \
               -v ~/malware:/malware \
               --name "${NAME}" \
               "${DOCKER_REPO_PREFIX}/${SUFFIX}"
}
```
