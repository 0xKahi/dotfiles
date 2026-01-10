#!/bin/bash

# Parse command-line arguments
FILTER=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --filter)
            if [[ -n "${2:-}" ]]; then
                FILTER="$2"
                shift 2
            else
                echo -e "\e[101;30mERROR\e[0m --filter requires an argument"
                exit 1
            fi
            ;;
        *)
            echo -e "\e[101;30mERROR\e[0m Unknown option: $1"
            exit 1
            ;;
    esac
done

# Main logic
gh search prs --author="$(gh api user -q .login)" --state=open --limit 100 --json repository,number | \
jq -r --arg filter "$FILTER" '
  .[] 
  | select(
      if $filter == "" then true 
      else 
        (.repository.nameWithOwner as $name | ($filter | split(",") | any(. as $f | $name | contains($f))))
      end
    )
  | "\(.repository.nameWithOwner) \(.number)"' | \
while read -r repo pr; do
  gh pr view "$pr" -R "$repo" --json number,title,headRefName,url,statusCheckRollup,reviewDecision,baseRefName | \
  jq --arg repo "$repo" '
    (.statusCheckRollup // []) as $rollup |
    ($rollup | map(if .__typename == "CheckRun" then .conclusion elif .__typename == "StatusContext" then .state else "UNKNOWN" end)) as $statuses |
    {
      repository: $repo,
      branch: .headRefName,
      pr_number: .number,
      pr_url: .url,
      checks_status: (
        if ($rollup | length) == 0 then "no_checks"
        elif ($statuses | any(. == "FAILURE" or . == "ERROR")) then "failing"
        elif ($statuses | all(. == "SUCCESS")) then "passing"
        else "pending"
        end
      ),
      failed_checks: ($statuses | map(select(. == "FAILURE" or . == "ERROR")) | length),
      successful_checks: ($statuses | map(select(. == "SUCCESS")) | length),
      total_checks: ($rollup | length)
    }'
done | jq -s '.'
