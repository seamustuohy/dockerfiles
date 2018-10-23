#!/bin/bash
# https://github.com/jessfraz/dockerfiles/blob/master/ykman/Dockerfile
set -e
set -o pipefail
set -x

init(){
        local pcscd_running=$(ps -aux | grep [p]cscd)
        if [ -z "$pcscd_running" ]; then
                echo "starting pcscd in backgroud"
                pcscd --debug --apdu
                pcscd --hotplug
        else
                echo "pcscd is running in already: ${pcscd_running}"
        fi
}

init

"$@"
