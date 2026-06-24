#!/usr/bin/env bash

set -e

if ! getent group "${CONTAINER_GID}" >/dev/null 2>&1; then
    echo "${CONTAINER_USER}:x:${CONTAINER_GID}:" >> /etc/group
fi

if ! getent passwd "${CONTAINER_UID}" >/dev/null 2>&1; then
    echo "${CONTAINER_USER}:x:${CONTAINER_UID}:${CONTAINER_GID}::${CONTAINER_HOME}:${CONTAINER_SHELL}" >> /etc/passwd
    echo "${CONTAINER_USER}:!:19000:0:99999:7:::" >> /etc/shadow
fi

mkdir -p "${CONTAINER_HOME}"
if [ -d /etc/skel ]; then
    cp -a /etc/skel/. "${CONTAINER_HOME}"
fi
chown -R "${CONTAINER_UID}:${CONTAINER_GID}" "${CONTAINER_HOME}"

mkdir -p /etc/sudoers.d
echo "${CONTAINER_USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${CONTAINER_USER}"
chmod 440 "/etc/sudoers.d/${CONTAINER_USER}"

echo "export USER=${CONTAINER_USER}" >> "${CONTAINER_HOME}/.bashrc"
adduser "${CONTAINER_USER}" docker

curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install > /tmp/nix.sh
chmod +x /tmp/nix.sh
env HOME="${CONTAINER_HOME}" USER="${CONTAINER_USER}" su "${CONTAINER_USER}" -c "/tmp/nix.sh --yes --no-daemon"

mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

cd /etc/machine
env HOME="${CONTAINER_HOME}" su "${CONTAINER_USER}" -c "pwd" > /tmp/logs 2>&1
env HOME="${CONTAINER_HOME}" su "${CONTAINER_USER}" -c "./home-manager.sh" >> /tmp/logs 2>&1