#!/bin/bash

function getVault {
    echo "Getiing vault cli..."
    url="https://releases.hashicorp.com/vault/0.7.3/vault_0.7.3_linux_amd64.zip"
    wget $url
    unzip vault_0.7.3_linux_amd64.zip
    echo "Vault cli has installed."
}

function getJQ {
    echo "Getiing jq..."
    url="http://stedolan.github.io/jq/download/linux64/jq"
    wget $url
    chmod +x ./jq
}

function exportVars {
    echo "Exporting vault vars..."
    export VAULT_TOKEN="87e7784b-d598-44fe-8962-c7c345a11eed"
    export VAULT_ADDR="http://0.0.0.0:1234"
}

exportVars

mkdir -p build/vault
cd build/vault

echo "Checking vault cli..."
[ -f vault_0.7.3_linux_amd64.zip ] && echo "Vault cli found." || getVault

echo "Checking json paser..."
[ -f jq ] && echo "jq found." || getJQ

echo "Generating token..."
token_response=$(./vault token-create  -wrap-ttl="5m" -policy=vault-spring-boot-policy -format=json)
wrapping_token=$(echo $token_response | ./jq '.wrap_info.token')

echo "Set application env..."
export ZUP_KEYVAULT_AUTH_TOKEN="$wrapping_token"

cd ../../
gradle bootRun
