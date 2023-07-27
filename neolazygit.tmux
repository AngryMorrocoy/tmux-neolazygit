#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

default_key_bindings_openlazygit="G"
tmux_option_open_lazygit="@open-lazygit"


set_open_lazygit_key_bindings () {
	local key_bindings=$(get_tmux_option "$tmux_option_open_lazygit" "$default_key_bindings_openlazygit")
	local key
	for key in $key_bindings; do
		tmux bind "$key" run "$CURRENT_DIR/scripts/open-lazygit.sh"
	done
}

main () {
    set_open_lazygit_key_bindings
}

main
