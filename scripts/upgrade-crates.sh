#!/bin/sh -v
set -e # exit on error
echo "### Upgrading crates..."
cargo update
cargo install cargo-edit
cargo upgrade --incompatible # from cargo-edit

# exit with "no changes" if no diff on .tool-versions
if [ `git diff -- Cargo.lock Cargo.toml | wc -l` -eq 0 ]; then
  echo "No new crate version found."
  exit 0
fi

cargo test
git commit -i Cargo.lock -i Cargo.toml -m "cargo update/upgrade"
