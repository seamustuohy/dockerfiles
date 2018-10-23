### Run Cutter alias
Assumes stuff to me analyzed is kept in /tmp/malware
Assume configurations kept in "${HOME}/.config/radare2"

```bash
cutter() {
     docker_del_stopped cutter
     local CONFDIR="${HOME}/.config/radare2"
     mkdir -p "${CONFDIR}"
     touch ${CONFDIR}/radare2rc
     mkdir -p ${CONFDIR}/r2-config
     xhost +local:docker && \
     docker run \
          --rm \
          -it \
          --name cutter \
          --cap-drop=ALL  \
          --cap-add=SYS_PTRACE \
          -e DISPLAY=$DISPLAY \
          -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
          -v /tmp/malware:/var/sharedFolder \
          -v ${CONFDIR}/radare2rc:/home/r2/.radare2rc \
          -v ${CONFDIR}/r2-config:/home/r2/.config/radare2 \
          ${DOCKER_REPO_PREFIX}/cutter
    xhost -local:docker
}
```

### Run cutter container with a bash shell
(Useful for debugging)
Assume configurations kept in "${HOME}/.config/radare2"

```bash
cutter_bash() {
     docker_del_stopped cutter
     local CONFDIR="${HOME}/.config/radare2"
     mkdir -p "${CONFDIR}"
     touch ${CONFDIR}/radare2rc
     mkdir -p ${CONFDIR}/r2-config
     xhost +local:docker && \
     docker run \
          --rm \
          -it \
          --name cutter \
          --cap-drop=ALL  \
          --cap-add=SYS_PTRACE \
          -e DISPLAY=$DISPLAY \
          -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
          -v /tmp/malware:/var/sharedFolder \
          -v ${CONFDIR}/radare2rc:/home/r2/.radare2rc \
          -v ${CONFDIR}/r2-config:/home/r2/.config/radare2 \
          --entrypoint "/bin/bash" \
           ${DOCKER_REPO_PREFIX}/cutter
    xhost -local:docker
}
```
