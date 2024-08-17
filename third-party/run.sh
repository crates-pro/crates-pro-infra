#!/usr/bin/bash
set -e

# Generate BUCK files for third-party dependencies
reindeer --third-party-dir . buckify

# Additional fixup for //third-party:mime_guess-2.0.x
old_env='"OUT_DIR": "\$(location :mime_guess-\(2\.0\.[0-9]\+\)-build-script-run\[out_dir\])",'
new_env='"MIME_TYPES_GENERATED_PATH": "\$(location :mime_guess-\1-build-script-run\[out_dir\])/mime_types_generated\.rs",'
sed -i "s|$old_env|$new_env|" ./BUCK

# Additional fixup for //submodules/crates-pro/tuplugins:plugin1 and //submodules/crates-pro/tuplugins:plugin2
cat << EOF >> ./BUCK
alias(
    name = "libtugraph-sys-build-script-run",
    actual = ":libtugraph-sys-0.1.2+3.5.0-build-script-run",
    visibility = ["PUBLIC"],
)
EOF
