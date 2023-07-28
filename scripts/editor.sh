#!/usr/bin/env bash
# A script that opens nvim from lazygit, if it was opened from a tmux pane, checks
# if exists a nvim remote server for that pane

# "editor.sh {{editor}} {{filename}} {{line}}"

FILENAME=$1
LINE=${2:-0}

# Check if there's a nvim instance in the origin pane and 'returns' its server socket,
# otherwise returns 0
get_nvim_socket () {
    local pid_of_origin=$(tmux list-panes -sF "#{pane_pid}" \
                            -f "#{m:#{pane_id},${LAZYGIT_ORIGIN_PANE}}")

    if [ -z $pid_of_origin ]; then
        echo 0
        return
    fi

    # Gets nvim pid on the pane of origin
    nvim_pid=$(pgrep -P "$pid_of_origin" vim)

    if [ -z $nvim_pid ]; then
        echo 0
        return
    fi

    nvim_socket=$(ls ${XDG_RUNTIME_DIR}/nvim* 2>/dev/null | grep $nvim_pid)

    if [ -z $nvim_socket ]; then
        echo 0
        return
    fi

    echo $nvim_socket
}

focus_nvim() {
    local origin_window=$(tmux list-panes -sF "#I" -f "#{m:#D,${LAZYGIT_ORIGIN_PANE}}")

    tmux selectw -t $origin_window
    tmux selectp -t $LAZYGIT_ORIGIN_PANE
}


main() {
    local socket=$(get_nvim_socket)
    # If no socket, it means no nvim, so just open inside lazygit ;)
    if [[ $socket == 0 ]]; then
        nvim +$LINE "$FILENAME"
        exit 0
    fi

    # Opens the file remotely in the expected line
    nvim --server "$socket" --remote "$FILENAME"
    nvim --server "$socket" --remote-send "<ESC>${LINE}gg"

    focus_nvim
}

main
