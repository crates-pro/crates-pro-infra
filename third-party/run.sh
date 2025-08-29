#!/usr/bin/bash
set -ex

# Generate BUCK files for third-party dependencies
reindeer --third-party-dir . buckify
