#!/usr/bin/bash
set -ex

# Build a target and copy the artifact to a destination
build_and_copy() {
    local target="$1"
    local dest="$2"
    local output=$(buck2 build "$target" --show-output | awk '{print $2}')
    cp "$output" "$dest"
}

# Clean up and prepare the destination directories
rm -rf build/crates-pro
mkdir -p build/crates-pro

# crates-pro executables
build_and_copy "//project/crates-pro:crates_pro" "build/crates-pro/crates_pro"
# crates-pro runtime dependencies
cp project/crates-pro/.env build/crates-pro

cp images/Dockerfile.crates-pro build
