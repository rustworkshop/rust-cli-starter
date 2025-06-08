#!/bin/sh -v
set -e # exit on error
echo "### Upgrading crates..."
cargo update
cargo install cargo-edit
cargo upgrade --incompatible # from cargo-edit

# exit with "no changes" if no diff on Cargo files
if [ `git diff -- "**Cargo.toml" Cargo.lock | wc -l` -eq 0 ]; then
  echo "No new crate version found."
  exit 0
fi

cargo test
git commit --include Cargo.lock -i "**Cargo.toml" -m "cargo update/upgrade"
