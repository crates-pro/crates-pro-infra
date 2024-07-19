#!/usr/bin/bash
reindeer --third-party-dir third-party buckify
buck2 build //submodules/crates-pro:crates_sync#check
buck2 build //submodules/crates-pro:model#check
buck2 build //submodules/crates-pro:repo_import#check
buck2 build //submodules/crates-pro:tudriver#check
buck2 build //third-party:libtugraph-sys-0.1.2+3.5.0#check
# buck2 build //submodules/crates-pro/tuplugins:plugin1#check
# buck2 build //submodules/crates-pro/tuplugins:plugin2#check
