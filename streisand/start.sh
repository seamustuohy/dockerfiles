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
set -x

# Read Only variables

# readonly PROG_DIR=$(readlink -m $(dirname $0))
# readonly PROGNAME="$( cd "$( dirname "BASH_SOURCE[0]" )" && pwd )"
readonly image_name="s2e/streisand"
readonly instance_name="streisand"

```docker run --name streisand-data s2e/streisand```

docker build -t streisand .
docker run -i -t --name streisand s2e/streisand


main() {
    if [[ "$run_command" == "bash" ]]; then
        run_command="bash"
    else
        run_command="make_keys.sh"
    fi

    local STREISTEMP=$(mktemp -d)
    echo "Your Local Temp directory is $STREISTEMP"
    local state=$(docker inspect --format "{{.State.Running}}" "${instance_name}" 2>/dev/null)
    if [[ "$state" == "true" ]]; then
        docker stop "${instance_name}"
    fi

docker run -it --rm \
       -v ~/home/s2e/.ssh:/root/.ssh \
       -v ~/home/s2e/projects/VPNs:/streisand/generated-docs/ \
       --name "${instance_name}" \
       "${image_name}" # "${run_command}"

    # Copy gpg files out of container
    docker cp "${instance_name}":'/root/.gnupg' "${STREISTEMP}/."
    # Delete container
    docker rm "${instance_name}"

    echo "Your Local Temp directory is $STREISTEMP"
# python3 -m http.server
}


build() {
    docker build --rm --force-rm -t "${image_name}" .
}

# check for positional param without unbound exception set
set +u
run_command="$1"
set -u
if [[ "$run_command" == "bash" ]]; then
    main bash
elif [[ "$run_command" == "build" ]]; then
    build
else
    main
fi
