#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUSTOM_LAZYGIT_CONFIG="$CURRENT_DIR/../lazygit/config.yml"

LAZYGIT_EDITOR="$CURRENT_DIR/editor.sh" # Check usage in lazygit/config.yml
LAZYGIT_CONFIG=$(echo "$(lazygit -cd)/config.yml")

openLazygit () {
    # Gets the pane id from where the script was called
    local LAZYGIT_ORIGIN_PANE=($(tmux display-message -p "#D"))

    # Opens a new tmux window running lazygit appending the needed config
    tmux neww \
        -e LAZYGIT_EDITOR=$LAZYGIT_EDITOR \
        -e LAZYGIT_ORIGIN_PANE=$LAZYGIT_ORIGIN_PANE \
        lazygit \
        -ucf "$LAZYGIT_CONFIG,$CUSTOM_LAZYGIT_CONFIG"
}

openLazygit
