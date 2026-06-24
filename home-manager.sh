#!/usr/bin/env bash

source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
"${HOME}/.nix-profile/bin/nix" run home-manager/master switch -- -b backup --flake .#container-machine