# cc-plugins

Claude Code plugin marketplace by Minhyeok Lee.

## Installation

```bash
# Add this marketplace
/plugin marketplace add minhyeoky/cc-plugins

# Install a plugin
/plugin install cc-event-exporter@minhyeoky-cc-plugins
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
