
# Using `setup.sh`

## To Setup Regular build

1. Edit Dockerfile-viper-depends to point to the r2 repo/branch you want to pull from
2. Edit Dockerfile-viper-repo to point to the viper repo/branch you want to pull from
3. Run build
```bash
setup.sh build
```

## To Setup development build from local repository

1. Edit Dockerfile-viper-depends to point to the r2 repo/branch you want to pull from
2. Edit Dockerfile-viper-repo to point to the viper repo/branch you want to pull from
3. Run build
```bash
setup.sh build_dev PATH_TO_LOCAL_VIPER_CODEBASE
```

## To run viper
```bash
setup.sh
```

## To run in a bash shell
```bash
setup.sh
```

## To run unit-tests in development build environment
```bash
setup.sh test
```

# Alias'

## Run viper-cli command line interface
```bash
viper() {
        docker_del_stopped viper
        docker run \
        -v /tmp/malware:/home/viper/workdir/malware \
        -v viper_data:/root/.viper \
        -it \
        --name viper \
        ${DOCKER_REPO_PREFIX}/viper
}
```

## Reconnect to last viper session
```bash
viper_reconnect() {
        local last_session=$(docker ps -a -q --filter='ancestor=s2e/viper' | head -n 1)
        if [[ "$last_session" != "" ]]; then
                docker start $last_session
                docker attach $last_session
        fi
}
```

## Run viper in a bash shell
```bash
viper_bash() {
        docker_del_stopped viper-bash
        docker -D run \
        -v /tmp/malware:/home/viper/workdir/malware \
        -v viper_data:/root/.viper \
        -it \
        --name viper-bash \
        ${DOCKER_REPO_PREFIX}/viper \
        bash

}
```
