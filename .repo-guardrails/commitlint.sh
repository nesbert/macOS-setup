#!/usr/bin/env bash
set -euo pipefail

commitlint() {
  local message_file="${1:?Pass the commit message file path.}"
  local message
  message="$(head -n 1 "$message_file")"
  local pattern='^(feat|fix|docs|test|refactor|chore|ci|build|perf|style|revert)(\([a-z0-9][a-z0-9-]*\))?: .+$'

  if [[ "$message" =~ $pattern ]]; then
    return 0
  fi

  printf 'Invalid commit message: "%s"\n' "$message" >&2
  printf 'Use <type>[optional scope]: <description>.\n' >&2
  return 1
}

commitlint "$@"
