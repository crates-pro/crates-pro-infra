FROM --platform=linux/amd64 almalinux:8.10-20240723

# Install necessary build tools
RUN dnf group install -y "Development Tools" \
    && dnf install -y curl

# Install Rust with nightly-2024-06-08 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-06-08 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Buck2 and Reindeer
RUN cargo install --git https://github.com/facebook/buck2.git --rev 2d341993 buck2
RUN dnf install -y openssl-devel
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev 7cfdcaf7 reindeer

# Install performance-benchmark test/runtime dependencies
RUN curl -O https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz \
    && tar -xzf Python-3.11.9.tgz \
    && cd Python-3.11.9 \
    && ./configure --enable-optimizations --prefix=/opt \
    && make -j8 \
    && make install \
    && cd .. \
    && /opt/bin/python3 -m pip install --upgrade pip \
    && /opt/bin/python3 -m pip install kaleido matplotlib plotly \
    && rm -rf Python-3.11.9.tgz Python-3.11.9
RUN ln -s /opt/bin/python3 /usr/local/bin/python

WORKDIR /workdir
