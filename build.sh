#!/usr/bin/bash
# crates-pro
buck2 build //submodules/crates-pro:crates_sync#check
buck2 build //submodules/crates-pro:model#check
buck2 build //submodules/crates-pro:repo_import#check
buck2 build //submodules/crates-pro:tudriver#check
buck2 build //submodules/crates-pro/tuplugins:plugin1#check
buck2 build //submodules/crates-pro/tuplugins:plugin2#check

# performance-benchmark
buck2 build //submodules/performance-benchmark:collector-lib#check
buck2 build //submodules/performance-benchmark:collector#check
buck2 build //submodules/performance-benchmark:flamegraph-fake#check
buck2 build //submodules/performance-benchmark:muti-rustc-perf#check
buck2 build //submodules/performance-benchmark:runtime-fake#check
buck2 build //submodules/performance-benchmark:rustc-fake#check
buck2 build //submodules/performance-benchmark:manager#check
