#!/usr/bin/env bash
set -euo pipefail

# Captures unmodified GraphController SSE output. It neither supplies model keys
# nor changes agent, model, or datasource records.
base_url="${DATAAGENT_DISCOVERY_URL:-http://127.0.0.1:8065}"
agent_id="${DATAAGENT_DISCOVERY_AGENT_ID:-1}"
run_id="$(date +%Y%m%dT%H%M%S)"
run_dir="$(cd "$(dirname "$0")" && pwd)/runs/${run_id}"
mkdir -p "$run_dir"

printf 'run_id=%s\nbase_url=%s\nagent_id=%s\ncommit=000e97f\n' \
  "$run_id" "$base_url" "$agent_id" > "$run_dir/metadata.txt"

run_case() {
  local case_id="$1"
  local question="$2"
  local case_dir="$run_dir/$case_id"
  mkdir -p "$case_dir"
  printf '%s\n' "$question" > "$case_dir/question.txt"
  curl --fail --no-buffer -G "$base_url/api/stream/search" \
    --data-urlencode "agentId=$agent_id" \
    --data-urlencode "conversationId=discovery-${run_id}-${case_id}" \
    --data-urlencode "query=$question" \
    > "$case_dir/timeline.sse"
}

run_case A '订单最多的用户是谁？他的订单完成率是多少？'
run_case B '在 2026-08-03 至 2026-08-09 和 2026-08-10 至 2026-08-16 两个固定比较周中，完成订单 GMV 下降最多的地区是哪里？再在该地区找下降最多的品类。'
run_case C '本周转化率下降，基于 fixture 的固定对比周分析原因。'
run_case D '如果转化率下降主要由新用户造成，就继续看渠道；否则分析老用户复购。'

cp "$(cd "$(dirname "$0")" && pwd)/fixture/cases.md" "$run_dir/cases-and-expected-outcomes.md"
cp "$(cd "$(dirname "$0")" && pwd)/fixture/grading-template.md" "$run_dir/grading.md"
printf '%s\n' "$run_dir"
