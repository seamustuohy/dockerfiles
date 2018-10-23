
### Most common Thug bash alias
Runs thug against a URL
NOTE: Requires utility commands

```bash
thug() {
    docker_del_stopped thug

    local URL="$1"
    if [[ -z "$URL" ]]; then
        echo "Error: You didn't specify a URL"
        printf "Usage:\n\t thug [URL]\n"
    else
        get_new_thug_ua
        docker run \
               -it \
               -v ${HOME}/malware/thug/logs:/home/thug/logs \
               --name thug \
               -e "URL=${URL}" \
               -e "UA=${THUG_UA_STRING}" \
               ${DOCKER_REPO_PREFIX}/thug
        # Save thugs logs to malware folder
        save_thug_logs $1
    fi
}
```

### Run Thug with a bash shell
Asks if you want to keep your logs from the thug session afterwards.
NOTE: Requires utility commands
```bash
thug_bash() {
       local instruction_output_path="$1"
       echo "PATH"
       echo "$instruction_output_path"

       docker_del_stopped thug_bash
       echo "Because you always forget the flags"
       echo "thug -FZM [URL]"
       echo "==================================="
       docker run \
              -it \
              --name thug_bash \
              ${DOCKER_REPO_PREFIX}/thug \
              bash
       echo "PATH"
       echo "$instruction_output_path"
       if [[ -z "$instruction_output_path" ]]; then
           local getem=$(printf "No\nYes" | dmenu -p "do you want your logs?" -l 3)
       fi
       if [[ "Yes" == "${getem}" ]]; then
           if [[ -z "$instruction_output_path" ]]; then
               local DATE=`date '+%Y-%m-%d_%H-%M-%S'`
               local instruction_output_path="${HOME}/malware/thug/logs/${DATE}"
           fi
           local image=$(docker ps -l --format "{{.ID}}")
           # local image=$(docker ps --last 10 -a --format "{{.Names}}::{{.Image}}" | dmenu -l 21 -p "Please choose the name of the thug image to pull from"|cut -d : -f 1)
          docker cp "${image}:/tmp/thug/logs/" "$instruction_output_path"
       fi
}
```


## Helpers

```bash
thug_unassisted() {
    docker_del_stopped thug

    local URL="$1"
    if [[ -z "$URL" ]]; then
        echo "Error: You didn't specify a URL"
        printf "Usage:\n\t thug [URL]\n"
    else
        get_new_thug_ua
        docker run \
               -v ${HOME}/malware/thug/logs:/home/thug/logs \
               --name thug \
               -e "URL=${URL}" \
               -e "UA=${THUG_UA_STRING}" \
               ${DOCKER_REPO_PREFIX}/thug
        # Save thugs logs to malware folder
        save_thug_logs $1
    fi
}

save_thug_logs() {
    local URL="$1"
    local tmpdir=$(mktemp -dt "$(basename "$0").XXXXX")
    local image=$(docker ps -l --format "{{.ID}}")
    local DATE=`date '+%Y-%m'`
    local output_path="${HOME}/malware/thug/logs/${DATE}"
    mkdir -p "${output_path}"
    docker cp "${image}:/tmp/thug/logs/." "${tmpdir}"
    local path=$(find "$tmpdir/" -maxdepth 1 -mindepth 1 -type d)
    local dirname=${path##*/}
    cp -fr "${path}" "${output_path}/${dirname##*/}"
    echo "Thug Output Path: ${output_path}/${dirname}"
    echo "${dirname},${THUG_UA_STRING},${URL}" | tee -a "${output_path}/thug.csv"
}

get_new_thug_ua() {
    useragents=(
            "winxpie60" \
            "winxpie61" \
            "winxpie70" \
            "winxpie80" \
            "winxpchrome20" \
            "winxpfirefox12" \
            "winxpsafari5" \
            "win2kie60" \
            "win2kie80" \
            "win7ie80" \
            "win7ie90" \
            "win7ie100" \
            "win7chrome20" \
            "win7chrome40" \
            "win7chrome45" \
            "win7chrome49" \
            "win7firefox3" \
            "win7safari5" \
            "win10ie110" \
            "osx10chrome19" \
            "osx10safari5" \
            "linuxchrome26" \
            "linuxchrome30" \
            "linuxchrome44" \
            "linuxchrome54" \
            "linuxfirefox19" \
            "linuxfirefox40" \
            "galaxy2chrome18" \
            "galaxy2chrome25" \
            "galaxy2chrome29" \
            "nexuschrome18" \
            "ipadchrome33" \
            "ipadchrome35" \
            "ipadchrome37" \
            "ipadchrome38" \
            "ipadchrome39" \
            "ipadchrome45" \
            "ipadchrome46" \
            "ipadchrome47" \
            "ipadsafari7" \
            "ipadsafari8" \
            "ipadsafari9" \
            )

    THUG_UA_STRING=${useragents[$RANDOM % ${#useragents[@]} ]}
}
```
