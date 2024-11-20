FROM --platform=linux/amd64 almalinux:8.10-20240923

# Install tools and dependencies
# Reindeer: openssl-devel
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y curl openssl-devel

# Install Rust with nightly-2024-07-21 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-07-21 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Buck2 and Reindeer
RUN cargo install --git https://github.com/facebook/buck2.git --rev dc95235c buck2
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev 6e9a4f27 reindeer

WORKDIR /workdir

# Command to keep container running
CMD ["tail", "-f", "/dev/null"]
