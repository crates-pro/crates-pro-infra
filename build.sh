#!/usr/bin/bash
set -e

build_and_copy() {
    local target="$1"
    local dest="$2"
    local output=$(buck2 build "$target" --show-output | awk '{print $2}')
    cp "$output" "$dest"
}

# Setup
rm -rf build
mkdir -p build/crates-pro build/performance-benchmark build/sensleak-rs

# crates-pro
build_and_copy "//project/crates-pro:crates_pro" "build/crates-pro/crates_pro"
build_and_copy "//project/crates-pro/tuplugins:plugin1" "build/crates-pro/plugin1.so"
build_and_copy "//project/crates-pro/tuplugins:plugin2" "build/crates-pro/plugin2.so"

# performance-benchmark
build_and_copy "//project/performance-benchmark:collector" "build/performance-benchmark/collector"
build_and_copy "//project/performance-benchmark:flamegraph-fake" "build/performance-benchmark/flamegraph-fake"
build_and_copy "//project/performance-benchmark:muti-rustc-perf" "build/performance-benchmark/muti-rustc-perf"
build_and_copy "//project/performance-benchmark:runtime-fake" "build/performance-benchmark/runtime-fake"
build_and_copy "//project/performance-benchmark:rustc-fake" "build/performance-benchmark/rustc-fake"
build_and_copy "//project/performance-benchmark:manager" "build/performance-benchmark/manager"

# sensleak-rs
build_and_copy "//project/sensleak-rs:api" "build/sensleak-rs/api"
build_and_copy "//project/sensleak-rs:scan" "build/sensleak-rs/scan"
