#!/usr/bin/env bash
set -eo pipefail

project_root() {
  echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../.."
}

drupal_root() {
  echo "$(project_root)/docroot"
}

drush_path() {
  echo "$(project_root)/vendor/bin/drush"
}

deploy_site() {
  readonly drush="$(drush_path)"

  pushd "$(drupal_root)" > /dev/null
    # Initial cache clear.
    "$drush" cache:rebuild

    # Import config.
    "$drush" config:import sync --yes

    # Run database updates.
    "$drush" updatedb --yes

    # Final cache clear.
    "$drush" cache:rebuild
  popd > /dev/null
}

sanitize_database() {
  readonly drush="$(drush_path)"

  pushd "$(drupal_root)" > /dev/null
    # Sanitize the users.
    "$drush" sql:sanitize

    # Clear the Drupal cache.
    "$drush" cache-rebuild
  popd > /dev/null
}
