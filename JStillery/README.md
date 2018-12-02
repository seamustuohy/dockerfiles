
# [JStillery](https://github.com/mindedsecurity/jstillery/)


### How to run

Source docker helpers

```sh
cd dockerfiles
source ./docker_helpers.sh
```

Use the following alias to start the server. (It will keep the terminal open)

```sh
jstillery() {
       docker_del_stopped jstillery

       docker run \
       --rm -it \
       -p 3001:3001 \
       --name jstillery \
       ${DOCKER_REPO_PREFIX}/jstillery
}
```

Go to `localhost:3001` in your browser.
