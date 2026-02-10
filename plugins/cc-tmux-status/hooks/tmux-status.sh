#!/usr/bin/env bash
set -euo pipefail

[[ -n "${TMUX_PANE:-}" ]] || exit 0

EVENT="${1:?usage: tmux-status.sh <event_name>}"

# Load emoji config
source "${CLAUDE_PLUGIN_ROOT}/hooks/tmux-status-config.sh"

# Helper: swap emoji prefix on current window name
update_prefix() {
  local emoji="$1"
  local name
  name=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')
  local old_emoji
  old_emoji=$(tmux show-option -w -t "$TMUX_PANE" -v @cc_emoji 2>/dev/null || true)
  if [[ -n "$old_emoji" && "$name" == "${old_emoji} "* ]]; then
    name="${name#"${old_emoji} "}"
  fi
  tmux set-option -w -t "$TMUX_PANE" @cc_emoji "$emoji"
  tmux rename-window -t "$TMUX_PANE" "${emoji} ${name}"
}

case "$EVENT" in
  SessionStart)
    tmux set-option -w -t "$TMUX_PANE" automatic-rename off
    update_prefix "$EMOJI_SESSION_START"
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
    name=$(tmux display-message -t "$TMUX_PANE" -p '#{window_name}')
    old_emoji=$(tmux show-option -w -t "$TMUX_PANE" -v @cc_emoji 2>/dev/null || true)
    if [[ -n "$old_emoji" && "$name" == "${old_emoji} "* ]]; then
      name="${name#"${old_emoji} "}"
    fi
    tmux rename-window -t "$TMUX_PANE" "$name"
    tmux set-option -w -t "$TMUX_PANE" -u @cc_emoji 2>/dev/null || true
    tmux set-option -w -t "$TMUX_PANE" automatic-rename on
    ;;
esac
