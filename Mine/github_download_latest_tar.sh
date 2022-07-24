#!/bin/env bash


# depends on: jq wget curl
# usage: <SCRIPT_PATH> "<USER>/<REPO>"

repo=$1

latest_json_response=$(curl -s "https://api.github.com/repos/${repo}/releases/latest")

latest_tag=$(echo $latest_json_response | jq -r  ".. .tag_name? // empty")
echo $latest_tag

latest_tarball_url=$(echo $latest_json_response | jq -r ".tarball_url" )
echo $latest_tarball_url

wget "$latest_tarball_url" -O /tmp/$latest_tag.tar.gz

