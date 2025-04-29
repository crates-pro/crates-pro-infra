#!/usr/bin/bash
set -euxo pipefail

# 'crates-pro' libs
buck2 build //project/crates-pro:analysis
buck2 build //project/crates-pro:data_transporter
buck2 build //project/crates-pro:model
buck2 build //project/crates-pro:repo_import
buck2 build //project/crates-pro:search
buck2 build //project/crates-pro:tudriver
# 'crates-pro' bins
buck2 build //project/crates-pro:crates_pro

# 'performance-benchmark' libs
buck2 build //project/performance-benchmark:collector-lib
# 'performance-benchmark' bins
buck2 build //project/performance-benchmark:collector
buck2 build //project/performance-benchmark:flamegraph-fake
buck2 build //project/performance-benchmark:muti-rustc-perf
buck2 build //project/performance-benchmark:runtime-fake
buck2 build //project/performance-benchmark:rustc-fake
buck2 build //project/performance-benchmark:manager

# 'sensleak-rs' libs
buck2 build //project/sensleak-rs:sensleak
# 'sensleak-rs' bins
buck2 build //project/sensleak-rs:api
buck2 build //project/sensleak-rs:scan

echo 'done'
