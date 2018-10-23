# s2e Dockerfiles

These are dockerfiles for software that I don't maintain. They usually have a README with some instructions and alias' that can be used with them. *I don't actively update those generic alias' so they may slightly off.* Some of these also have setup and running scripts. I've tried to make them generic, but they likely have some of the assumptions about my devices built in (where I keep things, etc.) So, don't blindly run these. Read through them first.

These are dockerfile, not VM's. So, don't assume the malware analysis Dockerfiles do ANYTHING to protect the device against malicious binaries. Be cautious when running these anywhere but on a cloud service. Generally, I stick to static analysis on these.


# Utility Bash Alias' for individual Docker Alias'
Borrowed from [JessFraz](https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc). You should take a look at her stuff.
```bash
docker_cleanup(){
        local containers
        mapfile -t containers < <(docker ps -aq 2>/dev/null)
        docker rm "${containers[@]}" 2>/dev/null
        local volumes
        mapfile -t volumes < <(docker ps --filter status=exited -q 2>/dev/null)
        docker rm -v "${volumes[@]}" 2>/dev/null
        local images
        mapfile -t images < <(docker images --filter dangling=true -q 2>/dev/null)
        docker rmi "${images[@]}" 2>/dev/null
}

docker_del_stopped(){
        local name=$1
        local state
        state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

        if [[ "$state" == "false" ]]; then
                docker rm "$name"
        else
            if [[ "$state" == "true" ]]; then
                echo "The container name \"${name}\" is already in use. Would you like to kill the current container and start a new one?"
                PS3='Pick a number: '
                options=("yes" "no")
                select opt in "${options[@]}"; do
                    case $opt in
                        "yes")
                            echo "Stopping Container Now"
                            docker_stop_and_delete "${name}"
                            break
                            ;;
                        "no")
                            echo "We can't start two instances of a docker container. Exiting..."
                            return
                            break
                            ;;
                        *) echo "Invalid option. Please choose again.";;
                    esac
                done
            fi
        fi
}

docker_stop_and_delete(){
        local name=$1
        local state
        state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

        if [[ "$state" == "true" ]]; then
                docker stop "$name"
        fi
        docker_del_stopped "$name"
}


relies_on(){
        for container in "$@"; do
                local state
                state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

                if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
                        echo "$container is not running, starting it for you."
                        $container
                fi
        done
}

docker_build_container(){
    local SRC_DIR="${1}"
    local NAME="${2}"
    # Go to source directory
    local DOCKER_REPO_PREFIX="s2e"
    cd "${SRC_DIR}"
    docker build --rm --force-rm -t "${DOCKER_REPO_PREFIX}/${NAME}" .
}

```
