#!/bin/sh
set -e # exit on error
./upgrade-rust.sh
./upgrade-crates.sh
