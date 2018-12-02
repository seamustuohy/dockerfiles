
# [OONI Run Link List Creator](https://github.com/ooni/run)

Do you get tired of pasting one link at a time into the [OONI Run Testing Interface?](https://run.ooni.io/) Now you can run this docker container against a text file that contains one URL per line to easily create an OONI run url.

### How to run

Source docker helpers

```sh
cd dockerfiles
source ./docker_helpers.sh
```

Add the following alias to your session

```sh
ooni-run_url() {
       local_url_file=$(readlink -f "${1}")
       docker_del_stopped oonirun
       docker run \
       -v "${local_url_file}:/tmp/local_urls.lsv" \
       -it \
       --rm \
       --name oonirun \
       ${DOCKER_REPO_PREFIX}/oonirun
}
```

Run ooni-run_url with path to a file with all the links you are interested in testing.

```sh
ooni-run_url /path/to/link/list.lsv
```

Copy the URL that is output and send it to whomever is doing testing for you.


### URL File

URL's should be full URL's `http[s]+://host.domain.tld/etc`
