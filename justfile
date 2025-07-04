#!/bin/bash

package_name := `sed -En 's/name[[:space:]]*=[[:space:]]*"([^"]+)"/\1/p' Cargo.toml | head -1`
package_version := `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/\1/p' Cargo.toml | head -1`
dockerhub_org := "ruststarter"

run-tests:
	cargo test --all

run-test TEST:
	cargo test --test {{TEST}}

debug TEST:
	cargo test --test {{TEST}} --features debug

bench:
	cargo bench

lint:
	cargo clippy

clean:
	cargo clean
	find . -type f -name "*.orig" -exec rm {} \;
	find . -type f -name "*.bk" -exec rm {} \;
	find . -type f -name ".*~" -exec rm {} \;	

build-image:
    mv docker/.dockerignore .dockerignore
    docker build -t {{package_name}}:{{package_version}} -f docker/Dockerfile .
    mv .dockerignore docker/.dockerignore

push-image:
    docker tag {{package_name}}:{{package_version}} {{dockerhub_org}}/{{package_name}}:{{package_version}}
    docker push {{dockerhub_org}}/{{package_name}}:{{package_version}}

upgrade-rust:
  scripts/upgrade-rust.sh

upgrade-crates:
  scripts/upgrade-crates.sh

upgrade: upgrade-rust upgrade-crates
