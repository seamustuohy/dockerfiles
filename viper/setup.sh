#!/usr/bin/env bash
#
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

# Setup

#Bash should terminate in case a command or chain of command finishes with a non-zero exit status.
#Terminate the script in case an uninitialized variable is accessed.
#See: https://github.com/azet/community_bash_style_guide#style-conventions
set -e
set -u

# TODO remove DEBUGGING
# set -x

# Read Only variables

# readonly PROG_DIR=$(readlink -m $(dirname $0))
# readonly PROGNAME="$( cd "$( dirname "BASH_SOURCE[0]" )" && pwd )"
readonly image_name="s2e/viper"
readonly dev_image_name="s2e/viper_dev"
readonly instance_name="viper"

main() {
    image_to_run="$1"
    local state=$(docker inspect --format "{{.State.Running}}" "${instance_name}" 2>/dev/null)
    if [[ "$state" == "true" ]]; then
        docker stop "${instance_name}"
    fi
    if [[ "$run_command" == "FALSE" ]]; then
        run_basic "${image_to_run}"
    else
        run_with_command "${image_to_run}"
    fi
}

run_with_command() {
    image_to_run="$1"
    docker run \
           -it \
           --device /dev/bus/usb \
           --device /dev/usb \
           --privileged \
           --name "${instance_name}" \
           "${image_to_run}" "${run_command}"
}

run_basic() {
    docker run \
           -it \
           --device /dev/bus/usb \
           --device /dev/usb \
           --privileged \
           --name "${instance_name}" \
           "${image_to_run}"
}

build_deps() {
    docker build -f Dockerfile-depends --rm --force-rm -t "s2e/viper_depends" .
}

build_regular() {
    docker build -f Dockerfile-viper-repo --rm --force-rm -t "s2e/viper_base" .
    docker build -f Dockerfile-viper --rm --force-rm -t "${image_name}" .
}

build_dev() {
    ## DEVELOPMENT
    local_repo_path="$1"
    # Create local path for viper code so we can pull it into image
    mkdir -p code
    rm -fr code/viper
    cp -fr "${local_repo_path}" code/viper
    docker build -f Dockerfile-viper-local --rm --force-rm -t "s2e/viper_base" .
    docker build -f Dockerfile-viper-dev --rm --force-rm -t "${dev_image_name}" .
}

build_volume() {
    echo "Creating Viper volume."
    if [[ "true" == $(docker volume ls | grep -q viper_data && echo true) ]];
    then
        echo "Viper data volume already created. Skipping..."
    else
        docker volume create viper_data
    fi
}

remove_volume() {
    echo "Deleting Viper volume."
    if [[ "true" == $(docker volume ls | grep -q viper_data && echo true) ]];
    then
        docker volume rm viper_data
    else
        echo "Viper data volume does not exist. Skipping..."
    fi
}

remove_images() {
    echo "Removing all viper images..."
    docker images -a | grep "s2e/viper" | awk '{print $3}' | xargs docker rmi
}

# check for positional param without unbound exception set
set +u
run_command="$1"
path_to_local_viper_codebase="$2"
set -u
if [[ "$run_command" == "bash" ]]; then
    # Run the normal viper image but to a shell instead of viper-cli
    main "${image_name}"
elif [[ "$run_command" == "build" ]]; then
    # Build the normal viper repo
    build_volume
    build_deps
    build_regular
elif [[ "$run_command" == "wipe_and_build" ]]; then
    # Build the normal viper repo
    remove_volume
    remove_images
    build_volume
    build_deps
    build_regular
elif [[ "$run_command" == "build_dev" ]]; then
    # Build the development environment from a local codebase
    build_deps
    build_dev "${path_to_local_viper_codebase}"
elif [[ "$run_command" == "dev" ]]; then
    # Run dev image but run bash instead of testing scripts
    run_command="bash"
    main "${dev_image_name}"
elif [[ "$run_command" == "test" ]]; then
    # Run default dev testing CMD instead of bash
    run_command="FALSE"
    main "${dev_image_name}"
else
    # Run the normal viper image for use
    run_command="FALSE"
    main "${image_name}"
fi
