#!/bin/bash

if ! command -v lure &>/dev/null; then
    lure up
    exit 0
fi

lure_url=$(curl -s https://gitea.arsenm.dev/api/v1/repos/Arsen6331/lure/releases | jq -r '.[0]["assets"] | map(select(.name | contains("'"$(uname -m)"'"))) | map( { (.name|tostring|split(".")[-1]): . } ) | add | .["rpm"]["browser_download_url"]')
sha_url=$(curl -s https://gitea.arsenm.dev/api/v1/repos/Arsen6331/lure/releases | jq -r '.[0]["assets"] | map(select(.name | contains("checksums.txt"))) | add | .["browser_download_url"]')

mkdir /tmp/lure
curl -fLo "/tmp/lure/lure.rpm" $lure_url
curl -fLo "/tmp/lure/checksums.txt" $sha_url

sha=$(sha256sum /tmp/lure/lure.rpm | awk '{print $1}')
cat /tmp/lure/checksums.txt | grep "$sha" &> /dev/null || {
    echo CHECKSUMS NOT MATCHING!
    exit 1
}

sudo dnf install /tmp/lure/lure.rpm

echo "Done!"
