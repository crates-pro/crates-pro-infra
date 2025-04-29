#!/bin/bash
set -ex

# Remove every uncommitted change inside every submodule
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -xfd
# Fetch and check out the branch each submodule is configured to track
git submodule update --remote --recursive --checkout
