#!/usr/bin/env bash
set -euo pipefail

OUTBOX="${CC_EVENT_OUTBOX:-/tmp/cc-events.jsonl}"

jq -c '{timestamp: now | todate, event: .type, data: .}' >> "$OUTBOX"
