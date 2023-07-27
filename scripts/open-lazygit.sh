CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUSTOM_LAZYGIT_CONFIG="$CURRENT_DIR/../lazygit/config.yml"

openLazygit () {
    local LAZYGIT_CONFIG=$(echo "$(lazygit -cd)/config.yml")
    # Opens a new tmux window running lazygit appending the needed config
    tmux neww \
        lazygit \
        -ucf $LAZYGIT_CONFIG,$CUSTOM_LAZYGIT_CONFIG
}

openLazygit
