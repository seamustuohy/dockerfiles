download_wiki(){
        docker_del_stopped wikiteam
        
        docker run --rm -it \
                -v "$(pwd):/data" \
                ${DOCKER_REPO_PREFIX}/wikiteam
        sudo chown -R "$(id -u).$(id -g)" "$local_path"
}
