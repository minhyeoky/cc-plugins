# cc-plugins

Claude Code plugin marketplace by Minhyeok Lee.

## Installation

```bash
# Add this marketplace
/plugin marketplace add minhyeoky/cc-plugins

# Install a plugin
/plugin install cc-event-exporter@minhyeoky-cc-plugins
/plugin install cc-tmux-status@minhyeoky-cc-plugins
```

## Plugins

### cc-event-exporter

Export all Claude Code hook events to a JSONL file for real-time monitoring and analysis.

Every hook event (SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, etc.) is appended to a JSONL file with a timestamp.

**Usage:**

```bash
# Monitor events in real-time
tail -f /tmp/cc-events.jsonl | jq .

# Custom output path
export CC_EVENT_OUTBOX=/path/to/events.jsonl
```

**Output format:**

```json
{
  "timestamp": "2025-01-01T00:00:00Z",
  "event": "PostToolUse",
  "data": { ... }
}
```

### cc-tmux-status

Show Claude Code session status as emoji prefix on your tmux window name.

While Claude Code is running, the tmux window name updates in real-time to reflect the current state:

| State | Emoji | Meaning |
|-------|-------|---------|
| 🧠 | Thinking | Session active / processing prompt |
| 🚧 | Tool use | Executing a tool |
| ❌ | Failure | Tool execution failed |
| 🔓 | Permission | Waiting for permission |
| 🔔 | Notification | Permission/idle notification |
| ✅ | Done | Task completed |

The original window name is restored when the session ends.

**Customization:**

Edit `hooks/tmux-status-config.sh` in the plugin directory to change the emoji mappings.
