#!/bin/bash
# Keeps personal signing details out of this repository's public logs.
# Run it after `bundle install` in every job that calls fastlane.
set -euo pipefail

# fastlane match prints tables that include the certificate holder's name and
# the provisioning profile ids. Remove the line that prints them.
table_printer="$(bundle exec ruby -e 'puts Gem::Specification.find_by_name("fastlane").gem_dir')/match/lib/match/table_printer.rb"
if [ -f "$table_printer" ]; then
  sed -i "" "/puts(Terminal::Table.new(params))/d" "$table_printer"
else
  echo "::error::table_printer.rb was not found in the installed fastlane."
  exit 1
fi

# match sends GH_PAT to GitHub as a base64 "owner:token" header. GitHub only
# hides the plain secret, so register the encoded form as a secret too.
if [ -n "${GH_PAT:-}" ]; then
  echo "::add-mask::$(printf '%s' "${GITHUB_REPOSITORY_OWNER}:${GH_PAT}" | base64 | tr -d '\n')"
fi
