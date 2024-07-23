#!/usr/bin/bash
set -e
# Generate BUCK files for third-party dependencies
reindeer --third-party-dir third-party buckify
reindeer --third-party-dir third-party-extra buckify

# Additional fixup for //third-party:mime_guess-2.0.x
old_env='"OUT_DIR": "\$(location :mime_guess-\(2\.0\.[0-9]\+\)-build-script-run\[out_dir\])",'
new_env='"MIME_TYPES_GENERATED_PATH": "\$(location :mime_guess-\1-build-script-run\[out_dir\])/mime_types_generated\.rs",'
sed -i "s|$old_env|$new_env|" third-party/BUCK

# Depend on "//third-party:clap-v4" for clap-4.x.x
# Depend on "//third-party:clap" for clap-3.x.x
cat << EOF >> third-party/BUCK
alias(
    name = "clap-v4",
    actual = "//third-party-extra:clap",
    visibility = ["PUBLIC"],
)
EOF
