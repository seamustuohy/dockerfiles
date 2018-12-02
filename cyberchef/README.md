
# [CyberChef](https://github.com/gchq/CyberChef)


### How to run

Source docker helpers

```sh
cd dockerfiles
source ./docker_helpers.sh
```

Use the following alias to start the server. (It will keep the terminal open)

```sh
cyberchef() {
       docker_del_stopped cyberchef

       docker run \
       --rm -it \
       -p 8080:8080 \
       --name cyberchef \
       ${DOCKER_REPO_PREFIX}/cyberchef

}
```

Go to `localhost:8080` in your browser.
