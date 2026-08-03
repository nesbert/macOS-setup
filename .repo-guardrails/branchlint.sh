#!/usr/bin/env bash
set -euo pipefail

policy_file="${REPO_GUARDRAILS_POLICY_FILE:-$(dirname "${BASH_SOURCE[0]}")/branch-names.conf}"
declare -a types exempt_exact exempt_prefixes

while IFS="=" read -r key value; do
  case "$key" in
    types) read -r -a types <<< "$value" ;;
    exempt_exact) read -r -a exempt_exact <<< "$value" ;;
    exempt_prefixes) read -r -a exempt_prefixes <<< "$value" ;;
  esac
done < "$policy_file"

type_pattern="$(IFS='|'; printf '%s' "${types[*]}")"
pattern="^(${type_pattern})/([0-9]+-)?[a-z0-9]+(-[a-z0-9]+)*$"

get_current_branch_name() {
  git branch --show-current
}

validate_branch_name() {
  local branch_name="$1"
  BRANCH_NAME_EXEMPT=false

  [[ -n "$branch_name" ]] || return 1

  for exact in "${exempt_exact[@]}"; do
    if [[ "$branch_name" == "$exact" ]]; then
      BRANCH_NAME_EXEMPT=true
      return 0
    fi
  done
  for prefix in "${exempt_prefixes[@]}"; do
    if [[ "$branch_name" == "$prefix"* && "$branch_name" != "$prefix" ]]; then
      BRANCH_NAME_EXEMPT=true
      return 0
    fi
  done

  local description="${branch_name#*/}"
  [[ "$branch_name" =~ $pattern && "$description" =~ [a-z] ]]
}

main() {
  local branch_name
  if (($#)); then
    branch_name="$1"
  else
    branch_name="$(get_current_branch_name)"
  fi
  if validate_branch_name "$branch_name"; then
    printf 'Valid branch name: "%s"' "$branch_name"
    "$BRANCH_NAME_EXEMPT" && printf ' (exempt)'
    printf '\n'
    return
  fi

  printf 'Invalid branch name: "%s"\n' "$branch_name" >&2
  printf 'Use <type>/[<issue-number>-]<short-description>.\n' >&2
  exit 1
}

main "$@"
