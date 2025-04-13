#!/usr/bin/env bash

# script to create/copy config files

script_dir="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
dry="0"

cd $script_dir
scripts=$(find runs -maxdepth 1 -mindepth 1 -executable -type f)

while [[ $# > 0 ]]; do
    if [[ "$1" == "--dry" ]]; then
        dry="1"
    fi
    shift
done

log() {
    if [[ $dry == "1" ]]; then
        echo "[DRY_RUN]: $@"
        return
    fi

    echo "$@"
}

execute() {
    log "execute: $@"
    if [[ $dry == "1" ]]; then
        return
    fi

    "$@"
}

log "--------------- dev-env ----------------"

copy_dir(){
    from=$1
    to=$2

    pushd $from > /dev/null
    dirs=$(find . -mindepth 1 -maxdepth 1 -type d)
    for dir in $dirs; do
       execute rm -rf $to/$dir 
       execute cp -r $dir $to/$dir 
    done
    popd > /dev/null
}

copy_file(){
    from=$1
    to=$2
    name=$(basename $from)

    execute rm $to/$name 
    execute cp $from $to/$name 
}

config_dir=$XDG_CONFIG_HOME
if [[ -z "$XDG_CONFIG_HOME" ]]; then
    config_dir="~/.config"
fi
log "conf: $config_dir"
cd $script_dir
copy_dir .config $config_dir

