## Decode bash alias

```bash
decode() {
        docker_del_stopped decode
        docker run \
        --rm \
        -it \
        --name decode \
        ${DOCKER_REPO_PREFIX}/decode \
        dcode -s $1
}
```
