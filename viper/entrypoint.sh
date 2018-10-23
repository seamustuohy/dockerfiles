#!/bin/bash

set -e
set -o pipefail
set -x

init(){
    # ClamAV
    if [[ ! -z  "$CLAMAV_ENABLED" ]]; then
        local clamav_running=$(ps -aux | grep [c]lamd)
        if [ -z "$clamav_running" ]; then

            echo "Starting clamav updater"
            freshclam -d &
            echo "Starting clamav in background"
            clamd &
        else
            echo "ClamAV is running in already: ${clamav_running}"
        fi
    fi
    # Tor
    if [[ ! -z  "$TOR_ENABLED" ]]; then
        local tor_running=$(ps -aux | grep [t]or)
        if [ -z "$tor_running" ]; then
            echo "starting Tor in backgroud"
            sudo -H -u viper /usr/bin/tor -f /etc/tor/torrc &
        else
            echo "Tor is running in already: ${tor_running}"
        fi
    fi
}

init

"$@"
