FROM almalinux:8.10-20240923

# Install tools and dependencies
# Reindeer: openssl-devel
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y curl openssl-devel

# Install Rust with nightly-2024-10-13 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-10-13 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Buck2 and Reindeer
RUN cargo install --git https://github.com/facebook/buck2.git --rev 7dd41c5a buck2
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev ebd86555 reindeer

WORKDIR /workdir

##### Copy all Buck2-required files except for 'project'
COPY platforms ./platforms
COPY prelude ./prelude
COPY toolchains ./toolchains
COPY .buckconfig ./.buckconfig
COPY .buckroot ./.buckroot
COPY BUCK ./BUCK
# use pre-generated third-party build rules
COPY third-party/vendor ./third-party/vendor
COPY third-party/BUCK ./third-party/BUCK
# (alternative approach) generate third-party build rules on-the-fly
# COPY third-party/fixups ./third-party/fixups
# COPY third-party/top ./third-party/top
# COPY third-party/vendor ./third-party/vendor
# COPY third-party/Cargo.toml ./third-party/Cargo.toml
# COPY third-party/reindeer.toml ./third-party/reindeer.toml
# COPY third-party/run.sh ./third-party/run.sh
# RUN cd ./third-party && ./run.sh

##### Copy project files for 'crates-pro'
# source directories
COPY project/crates-pro/analysis            ./project/crates-pro/analysis
COPY project/crates-pro/crates_pro          ./project/crates-pro/crates_pro
COPY project/crates-pro/data_transporter    ./project/crates-pro/data_transporter
COPY project/crates-pro/model               ./project/crates-pro/model
COPY project/crates-pro/repo_import         ./project/crates-pro/repo_import
COPY project/crates-pro/search              ./project/crates-pro/search
COPY project/crates-pro/tudriver            ./project/crates-pro/tudriver
# source files
COPY project/crates-pro/BUCK                ./project/crates-pro/BUCK
COPY project/crates-pro/.env                ./project/crates-pro/.env
##### Copy project files for 'performance-benchmark'
# source directories
COPY project/performance-benchmark/collector    ./project/performance-benchmark/collector
COPY project/performance-benchmark/data_manage  ./project/performance-benchmark/data_manage
# source files
COPY project/performance-benchmark/BUCK     ./project/performance-benchmark/BUCK
##### Copy project files for 'sensleak-rs'
# source directories
COPY project/sensleak-rs/src                ./project/sensleak-rs/src
# source files
COPY project/sensleak-rs/BUCK               ./project/sensleak-rs/BUCK
