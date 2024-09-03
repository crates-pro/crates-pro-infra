FROM --platform=linux/amd64 almalinux:8.10-20240723

# Install tools and dependencies
# Reindeer: openssl-devel
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y curl openssl-devel

# Install Rust with nightly-2024-06-08 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-06-08 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Buck2 and Reindeer
RUN cargo install --git https://github.com/facebook/buck2.git --rev 7764d721 buck2
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev 2bbaed25 reindeer

WORKDIR /workdir
