#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_LAZYGIT_CONFIG="$CURRENT_DIR/../lazygit/config.yml"
LAZYGIT_EDITOR="$CURRENT_DIR/editor.sh"
LAZYGIT_CONFIG="$(lazygit -cd)/config.yml"

WINDOW_ID_OPTION="@neolazygit-window-id"
ORIGIN_PANE_OPTION="@neolazygit-origin-pane"

openLazygit() {
  local ORIGIN_PANE
  ORIGIN_PANE="$(tmux display-message -p "#D")"

  local SESSION_ID
  SESSION_ID="$(tmux display-message -p -t "$ORIGIN_PANE" "#{session_id}")"

  local CURRENT_PATH
  CURRENT_PATH="$(tmux display-message -p -t "$ORIGIN_PANE" "#{pane_current_path}")"

  tmux set-option -t "$SESSION_ID" -q "$ORIGIN_PANE_OPTION" "$ORIGIN_PANE"

  local WINDOW_ID
  WINDOW_ID="$(tmux show-options -t "$SESSION_ID" -qv "$WINDOW_ID_OPTION")"

  if [ -n "$WINDOW_ID" ] && tmux list-windows -t "$SESSION_ID" -F "#{window_id}" | grep -Fxq "$WINDOW_ID"; then
    tmux select-window -t "$WINDOW_ID"
  else
    local WINDOW_NAME
    WINDOW_NAME="LG-${ORIGIN_PANE//%/}"

    WINDOW_ID="$(tmux new-window -P -F "#{window_id}" -n "$WINDOW_NAME" -c "$CURRENT_PATH" \
      -e LAZYGIT_EDITOR="$LAZYGIT_EDITOR" \
      -e LAZYGIT_SESSION_ID="$SESSION_ID" \
      lazygit \
      -ucf "$LAZYGIT_CONFIG,$CUSTOM_LAZYGIT_CONFIG")"

    tmux set-option -t "$SESSION_ID" -q "$WINDOW_ID_OPTION" "$WINDOW_ID"
  fi
}

openLazygit
