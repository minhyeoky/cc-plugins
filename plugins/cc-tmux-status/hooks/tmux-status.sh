#!/usr/bin/env bash
set -euo pipefail

[[ -n "${TMUX_PANE:-}" ]] || exit 0

EVENT="${1:?usage: tmux-status.sh <event_name>}"

# Load emoji config
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/tmux-status-config.sh"

# Helper: swap emoji prefix, keeping original name
update_prefix() {
  local emoji="$1"
  local orig
  orig=$(tmux show-option -w -t "$TMUX_PANE" -v @cc_orig_name 2>/dev/null || true)
  [[ -n "$orig" ]] && tmux rename-window -t "$TMUX_PANE" "${emoji} ${orig}"
}

case "$EVENT" in
  SessionStart)
    ORIG=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')
    tmux set-option -w -t "$TMUX_PANE" @cc_orig_name "$ORIG"
    tmux set-option -w -t "$TMUX_PANE" automatic-rename off
    tmux rename-window -t "$TMUX_PANE" "${EMOJI_SESSION_START} ${ORIG}"
    ;;
  UserPromptSubmit)
    update_prefix "$EMOJI_USER_PROMPT_SUBMIT"
    ;;
  PreToolUse)
    update_prefix "$EMOJI_PRE_TOOL_USE"
    ;;
  PostToolUse)
    update_prefix "$EMOJI_POST_TOOL_USE"
    ;;
  PostToolUseFailure)
    update_prefix "$EMOJI_POST_TOOL_USE_FAILURE"
    ;;
  PermissionRequest)
    update_prefix "$EMOJI_PERMISSION_REQUEST"
    ;;
  Notification)
    update_prefix "$EMOJI_NOTIFICATION"
    ;;
  Stop)
    update_prefix "$EMOJI_STOP"
    ;;
  SessionEnd)
    ORIG=$(tmux show-option -w -t "$TMUX_PANE" -v @cc_orig_name 2>/dev/null || true)
    if [[ -n "$ORIG" ]]; then
      tmux rename-window -t "$TMUX_PANE" "$ORIG"
    fi
    tmux set-option -w -t "$TMUX_PANE" -u @cc_orig_name 2>/dev/null || true
    tmux set-option -w -t "$TMUX_PANE" automatic-rename on
    ;;
esac
