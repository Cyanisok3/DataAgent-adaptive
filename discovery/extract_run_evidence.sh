#!/usr/bin/env bash
set -euo pipefail

run_dir="${1:?usage: extract_run_evidence.sh RUN_DIR}"

for case_dir in "$run_dir"/[A-D]; do
  [[ -d "$case_dir" ]] || continue
  events="$case_dir/events.jsonl"

  awk '/^data:/{sub(/^data:/, ""); print}' "$case_dir/timeline.sse" > "$events"

  jq -sr '
    reduce .[] as $event ({last: null, rows: []};
      ($event.stepId // ($event.eventType + "-terminal")) as $key
      | if $key != .last then
          .rows += [{eventType: $event.eventType, nodeName: $event.nodeName,
                     stepId: $event.stepId, error: $event.error,
                     complete: $event.complete}]
          | .last = $key
        else . end)
    | .rows[]
    | [(.eventType // ""), (.nodeName // ""), (.stepId // ""),
       (.error | tostring), (.complete | tostring)]
    | @tsv
  ' "$events" > "$case_dir/trajectory.tsv"

  jq -sr '[.[] | select(.nodeName == "PlannerNode") | (.text // "")] | join("")' \
    "$events" > "$case_dir/planner-output.txt"

  jq -sr '[.[] | select((.textType == "SQL") or
                         ((.nodeName // "") | test("SqlGenerate|SqlExecute")))
                   | (.text // "")] | join("")' \
    "$events" > "$case_dir/sql-python.txt"

  jq -sr '[.[] | select((.textType == "RESULT_SET") or
                         ((.nodeName // "") | test("Python.*Execute|PythonExecute")))
                   | (.text // "")] | join("")' \
    "$events" > "$case_dir/intermediate-results.txt"

  jq -sr '[.[] | select((.eventType == "FINAL_ANSWER") or
                         (.nodeName == "ReportGeneratorNode" and .textType == "MARK_DOWN"))
                   | (.text // "")] | join("")' \
    "$events" > "$case_dir/final-report.md"

  jq -sr '[.[] | select(.error == true) |
            {eventType, nodeName, stepId, textType, text}]' \
    "$events" > "$case_dir/errors.json"
done
