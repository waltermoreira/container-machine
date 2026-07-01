# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ENV container container

RUN apt-get update && \
    apt-get install -y \
    ca-certificates curl \
    dbus systemd openssh-server net-tools iproute2 iputils-ping curl wget vim-tiny man sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    yes | unminimize
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN <<EOF /usr/bin/bash -e
set -ex
cat <<END >/etc/apt/sources.list.d/docker.sources 
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
END
EOF
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN >/etc/machine-id
RUN >/var/lib/dbus/machine-id

RUN systemctl set-default multi-user.target
RUN systemctl mask \
      dev-hugepages.mount \
      sys-fs-fuse-connections.mount \
      systemd-update-utmp.service \
      systemd-tmpfiles-setup.service \
      console-getty.service
RUN systemctl disable \
      networkd-dispatcher.service

RUN sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config

COPY . /etc/machine/
