#!/usr/bin/env bash
set -eo pipefail

main() {
  local site="$1"
  local target_env="$2"
  local source_branch="$3"
  local deployed_tag="$4"
  local repo_url="$5"
  local repo_type="$6"

  local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  . "${current_dir}/../common.sh"

  deploy_site

  if [[ "$source_branch" != "$deployed_tag" ]]; then
      echo "${site}.${target_env}: Deployed branch ${source_branch} as ${deployed_tag}."
  else
      echo "${site}.${target_env}: Deployed ${deployed_tag}."
  fi
}

main "$@"
