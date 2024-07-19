FROM --platform=linux/amd64 ubuntu:24.04

# Configure apt to handle network issues and disable unnecessary installs
RUN echo \
    'Acquire::Retries "100";' \
    'Acquire::https::Timeout "240";' \
    'Acquire::http::Timeout "240";' \
    'APT::Get::Assume-Yes "true";' \
    'APT::Install-Recommends "false";' \
    'APT::Install-Suggests "false";' \
    'Debug::Acquire::https "true";' \
    > /etc/apt/apt.conf.d/99custom
RUN apt-get update

# Install essential dependencies
RUN apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git

# Install reindeer compilation dependencies
RUN apt-get install -y \
    libssl-dev \
    pkg-config

# Install crates-pro compilation dependencies
RUN apt-get install -y \
    clang \
    cmake \
    lld \
    python3

# Install Rust with nightly-2024-04-28 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-04-28 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Buck2 and reindeer
RUN cargo install --git https://github.com/facebook/buck2.git --rev ed701c88 buck2
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev dd39db91 reindeer

WORKDIR /workdir

COPY . .
