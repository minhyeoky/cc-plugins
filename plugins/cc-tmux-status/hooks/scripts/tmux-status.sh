#!/usr/bin/env bash
set -euo pipefail

[[ -n "${TMUX_PANE:-}" ]] || exit 0

EVENT="${1:?usage: tmux-status.sh <event_name>}"

# Load emoji config
source "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/tmux-status-config.sh"

# Store original window name in @cc_base_name so emoji never duplicates
update_prefix() {
  local emoji="$1"
  local name
  name=$(tmux show-option -w -t "$TMUX_PANE" -v @cc_base_name 2>/dev/null || true)
  [[ -z "$name" ]] && name=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')
  tmux set-option -w -t "$TMUX_PANE" @cc_emoji "$emoji"
  tmux rename-window -t "$TMUX_PANE" "${emoji} ${name}"
}

remove_prefix() {
  local name
  name=$(tmux show-option -w -t "$TMUX_PANE" -v @cc_base_name 2>/dev/null || true)
  [[ -z "$name" ]] && name=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')
  tmux rename-window -t "$TMUX_PANE" "$name"
  tmux set-option -w -t "$TMUX_PANE" -u @cc_emoji 2>/dev/null || true
  tmux set-option -w -t "$TMUX_PANE" -u @cc_base_name 2>/dev/null || true
}

case "$EVENT" in
  SessionStart)
    tmux set-option -w -t "$TMUX_PANE" automatic-rename off
    tmux set-option -w -t "$TMUX_PANE" @cc_base_name \
      "$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')"
    update_prefix "$EMOJI_SESSION_START"
    ;;
  SessionEnd)
    remove_prefix
    tmux set-option -w -t "$TMUX_PANE" automatic-rename on
    ;;
  UserPromptSubmit)   update_prefix "$EMOJI_USER_PROMPT_SUBMIT" ;;
  PreToolUse)         update_prefix "$EMOJI_PRE_TOOL_USE" ;;
  PostToolUse)        update_prefix "$EMOJI_POST_TOOL_USE" ;;
  PostToolUseFailure) update_prefix "$EMOJI_POST_TOOL_USE_FAILURE" ;;
  PermissionRequest)  update_prefix "$EMOJI_PERMISSION_REQUEST" ;;
  Notification)       update_prefix "$EMOJI_NOTIFICATION" ;;
  Stop)               update_prefix "$EMOJI_STOP" ;;
esac
