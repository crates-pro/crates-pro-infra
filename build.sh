#!/usr/bin/bash
buck2 build //submodules/crates-pro:crates_sync#check
buck2 build //submodules/crates-pro:model#check
buck2 build //submodules/crates-pro:repo_import#check
buck2 build //submodules/crates-pro:tudriver#check
buck2 build //submodules/crates-pro/tuplugins:plugin1#check
buck2 build //submodules/crates-pro/tuplugins:plugin2#check
