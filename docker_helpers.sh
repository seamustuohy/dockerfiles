#!/usr/bin/env bash
#
# This file is part of my dockerfiles
# Copyright © 2018 seamus tuohy, <code@seamustuohy.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the included LICENSE file for details.

DOCKER_REPO_PREFIX="s2e"

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
