#!/bin/sh -v
set -e # exit on error
echo "### Upgrading rust..."
asdf plugin update rust
latest=`asdf list all rust | tail -n 1`
echo $latest
asdf install rust $latest
asdf local rust $latest

# exit with "no changes" if no diff on .tool-versions
if [ `git diff -- .tool-versions | wc -l` -eq 0 ]; then
  echo "No new rust version found."
  exit 0
fi

cargo test
git commit -i .tool-versions -m "Upgrade rust to latest"
