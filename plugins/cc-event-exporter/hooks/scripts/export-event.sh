#!/usr/bin/env bash
set -euo pipefail

OUTBOX="${CC_EVENT_OUTBOX:-/tmp/cc-events.jsonl}"
EVENT="${1:?usage: export-event.sh <event_name>}"

jq -c --arg event "$EVENT" '{timestamp: (now | todate), event: $event, data: .}' >> "$OUTBOX"
