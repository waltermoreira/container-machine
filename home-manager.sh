#!/usr/bin/env bash

source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
MACHINE=$("${HOME}/.nix-profile/bin/nix" eval --raw "path:$(pwd)#machineName")
"${HOME}/.nix-profile/bin/nix" run home-manager/master switch -- -b backup --flake ".#$MACHINE"