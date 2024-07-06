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

    # Gets all "nvim" processes running in the pane of origin
    NVIM_PIDS=$(pstree -paT $pid_of_origin | \
        grep -E .\+nvim, | \
        cut -d, -f2 | \
        cut -d" " -f1)

    # Find the first PID that has an nvim socket assigned
    for nvim_pid in $NVIM_PIDS; do
        nvim_socket=$(ls ${XDG_RUNTIME_DIR}/nvim* 2>/dev/null | grep $nvim_pid)
        # Returns the found socket
        if [ ! -z $nvim_socket  ]; then
            echo $nvim_socket
            return
        fi
    done

    echo 0
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

    focus_nvim

    # Opens the file remotely in the expected line
    nvim --server "$socket" --remote "$(realpath "$FILENAME")"
    nvim --server "$socket" --remote-send "<ESC>${LINE}gg"
}

main
