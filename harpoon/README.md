

## Run Harpoon (Plain text config)
Assumes a harpoon config is stored in ~/dotfiles/private/harpoon
Assumes any artifacts you need are stored in /tmp/malware

```bash
harpoon() {
       docker_del_stopped harpoon
       mkdir -p /tmp/malware

       docker run \
       --rm -it \
       --name harpoon \
       -v /tmp/malware:/home/harpoon/malware \
       -v ~/dotfiles/private/harpoon:/home/harpoon/.config/harpoon/ \
       ${DOCKER_REPO_PREFIX}/harpoon
}
```


## Run Harpoon (Encrypted config file)
If you store your harpoon configs in a GPG encrypted file


```bash
harpoon_gpg() {
       docker_del_stopped harpoon

       local config_file="${HOME}/dotfiles/private/harpoon/config.gpg"
       local tmpdir=$(mktemp -dt "$(basename "$0").XXXXX")
       gpg -o "${tmpdir}/config" -d "${config_file}"

       docker run \
       --rm -it \
       --name harpoon \
       -v ~/malware:/home/harpoon/malware \
       -v "${tmpdir}:/home/harpoon/.config/harpoon/" \
       ${DOCKER_REPO_PREFIX}/harpoon

       rm -fr "${tmpdir}"
}
```
