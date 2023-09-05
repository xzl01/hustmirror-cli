#!/bin/bash
set -e

config_file="/etc/pacman.d/mirrorlist"
update_command="pacman -Syy --noconfirm"
recover_item="arch"

source "$(realpath ${BASH_SOURCE%/*})/run_test.sh"
