#!/usr/bin/env bash
CARGO_PATH=$(which cargo)

# Workaround, telling //third-party/fixups/borsh/fixups.toml the real path to `cargo`.
# This is currently required, since proc-macro-crate-3.1.0 relies on the `cargo` command
# to determine workspace_manifest_path.
mkdir third-party/fixups/borsh
cat << EOF > third-party/fixups/borsh/fixups.toml
cargo_env = true
env = { CARGO = "$CARGO_PATH" }
EOF

reindeer --third-party-dir third-party buckify
buck2 build //submodules/crates-pro/crates_sync:crates_sync
