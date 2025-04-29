FROM almalinux:9.5-20250411

# Install tools and dependencies
# Reindeer: openssl-devel
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y glibc-langpack-en sudo tzdata \
    && dnf install -y openssl-devel

# Install Docker
ARG DOCKER_GID
RUN groupadd -g $DOCKER_GID docker
RUN dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo \
    && dnf install -y docker-ce docker-ce-cli containerd.io

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.28.12/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Create and switch to user
ARG USERNAME
ARG USER_UID
RUN useradd -m -s /bin/bash -u $USER_UID $USERNAME \
    && mkdir -p /etc/sudoers.d \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG docker $USERNAME
USER $USERNAME

# Install Rust with nightly-2025-02-16 (required by Buck2) and nightly-2025-01-10 toolchains
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2025-02-16 -y
ENV PATH="/home/$USERNAME/.cargo/bin:$PATH"
# rust-mir-checker: clippy, rustfmt, rustc-dev, rust-src, rust-std, llvm-tools-preview
RUN rustup toolchain install nightly-2025-01-10 --component clippy,rustfmt,rustc-dev,rust-src,rust-std,llvm-tools-preview

# Install Buck2 and Reindeer
RUN cargo +nightly-2025-02-16 install --git https://github.com/yxdai-nju/buck2.git --rev e575b5b buck2
RUN cargo +nightly-2025-02-16 install --git https://github.com/yxdai-nju/reindeer.git --rev 6ab7154 reindeer

# Create and set permissions for workspace directory
USER root
RUN mkdir -p /workspace && chown $USERNAME:$USERNAME /workspace
USER $USERNAME

WORKDIR /workspace

ENV TZ=Asia/Shanghai
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
