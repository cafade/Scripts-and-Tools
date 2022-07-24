#!/bin/env bash


# depends on: jq wget curl

repo="docker/compose"
file_name="docker-compose-Linux-x86_64"

latest_json_response=$(curl -s "https://api.github.com/repos/${repo}/releases/latest")

latest_tag=$(echo $latest_json_response | jq -r  ".. .tag_name? // empty")

wget "https://github.com/${repo}/releases/download/${latest_tag}/${file_name}" -O "/tmp/${file_name}"

