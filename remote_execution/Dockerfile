FROM almalinux:9.6-20250825

ARG NPROC=8

# Install build dependencies
# cc (crates.io): clang
# cmake (crates.io), libgit2 (Dockerfile): cmake
# OpenSSL 3.2.2 (Dockerfile): perl-FindBin, perl-IPC-Cmd, perl-Pod-Html
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y glibc-langpack-en sudo tzdata \
    && dnf install -y clang cmake perl-FindBin perl-IPC-Cmd perl-Pod-Html

# Install OpenSSL 3.2.2 from source
# Required by: openssl-sys (crates.io), libssh2-sys (crates.io), libgit2 1.9.1 (Dockerfile)
# enable-md2: sudo (Dockerfile)
# enable-sm4: openssl (crates.io)
WORKDIR /tmp
RUN curl -LO https://www.openssl.org/source/openssl-3.2.2.tar.gz \
    && tar -xzf openssl-3.2.2.tar.gz \
    && cd openssl-3.2.2 \
    && ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared enable-md2 enable-sm4 \
    && make -j$(NPROC) \
    && make install \
    && echo "/usr/local/ssl/lib64" > /etc/ld.so.conf.d/openssl.conf \
    && ldconfig \
    && ln -sf /usr/local/ssl/bin/openssl /usr/bin/openssl

# Set OpenSSL environment variables
ENV PATH="/usr/local/ssl/bin:$PATH" \
    OPENSSL_DIR="/usr/local/ssl"

# Install libgit2 1.9.1 from source
# Required by: libgit2-sys (crates.io)
WORKDIR /tmp
RUN curl -LO https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.1.tar.gz \
    && tar -xzf v1.9.1.tar.gz \
    && cd libgit2-1.9.1 \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
                -DOPENSSL_ROOT_DIR=/usr/local/ssl \
                -DBUILD_SHARED_LIBS=ON \
    && make -j$(NPROC) \
    && make install \
    && ldconfig

# Set libgit2 environment variables
ENV PATH="/usr/local/bin:$PATH"

# Set library environment variables
ENV LD_LIBRARY_PATH="/usr/local/ssl/lib64:/usr/local/lib64:/usr/lib64" \
    PKG_CONFIG_PATH="/usr/local/ssl/lib64/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig"

# Create and switch to user
ARG USERNAME="rust"
ARG USER_UID="1000"
RUN useradd -m -s /bin/bash -u $USER_UID $USERNAME \
    && mkdir -p /etc/sudoers.d \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Install Rust with nightly-2025-06-20 toolchain (same as Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2025-06-20 -y
ENV PATH="/home/$USERNAME/.cargo/bin:$PATH"

# Install NativeLink with nightly-2025-05-21 toolchain (as in NativeLink `MODULE.bazel`)
RUN cargo +nightly-2025-05-21 install --git https://github.com/TraceMachina/nativelink.git --rev 3f9e037 nativelink

# Create and set permissions for directories
USER root
RUN mkdir -p /workdir && chown $USERNAME:$USERNAME /workdir
RUN mkdir -p /tmp/nativelink && chown $USERNAME:$USERNAME /tmp/nativelink
USER $USERNAME

WORKDIR /workdir

# Download resources required by `//third-party/vendor/utoipa-swagger-ui-9.0.2-patch1/src/lib.rs`
RUN curl -L -o swagger-ui-5.17.14.zip https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip \
    && unzip -j swagger-ui-5.17.14.zip "swagger-ui-5.17.14/dist/*" -d ./swagger-ui-5.17.14-dist \
    && rm -f swagger-ui-5.17.14.zip

ENV TZ=Asia/Shanghai
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

COPY basic_cas.json5 .
CMD ["nativelink", "./basic_cas.json5"]
