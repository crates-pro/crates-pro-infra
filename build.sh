#!/usr/bin/env bash
CARGO_PATH=$(which cargo)
OPENSSL_DIR=$(./find-openssl)

# Workaround for borsh-1.5.1.
# This is currently necessary because proc-macro-crate-3.1.0 relies on the `cargo` command.
# See https://github.com/bkchr/proc-macro-crate/blob/444cbccdac85e50f8aeedd49c3a85f6683c937e2/src/lib.rs#L244.
mkdir third-party/fixups/borsh
cat << EOF > third-party/fixups/borsh/fixups.toml
cargo_env = true
env = { CARGO = "$CARGO_PATH" }
EOF

# Workaround for openssl-sys-0.9.102.
# This sets the `OPENSSL_DIR` environment variable,
# allowing the build script to find the OpenSSL installation.
mkdir third-party/fixups/openssl-sys
cat << EOF > third-party/fixups/openssl-sys/fixups.toml
env = { CARGO_PKG_VERSION = "0.9.102" }
[[buildscript]]
[buildscript.rustc_flags]
env = { OPENSSL_DIR = "$OPENSSL_DIR", CARGO_PKG_VERSION = "0.9.102", OPT_LEVEL = "3" }
EOF

# Workaround for libssh2-sys-0.3.0.
# This sets the `DEP_OPENSSL_INCLUDE` environment variable,
# allowing the build script to find the OpenSSL headers.
mkdir third-party/fixups/libssh2-sys
cat << EOF > third-party/fixups/libssh2-sys/fixups.toml
[[buildscript]]
[buildscript.gen_srcs]
env = { DEP_OPENSSL_INCLUDE = "$OPENSSL_DIR/include", PROFILE = "release", OPT_LEVEL = "3" }
EOF

reindeer --third-party-dir third-party buckify
# buck2 build //submodules/crates-pro:crates_sync
# buck2 build //submodules/crates-pro:model
buck2 build //submodules/crates-pro:repo_import
