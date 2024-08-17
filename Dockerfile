FROM --platform=linux/amd64 tugraph/tugraph-compile-centos8:1.3.2

# Install Rust with nightly-2024-06-08 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-06-08 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Buck2, Reindeer and NativeLink
RUN cargo install --git https://github.com/facebook/buck2.git --rev c785bfed buck2
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev c8bd1164 reindeer
RUN cargo install --git https://github.com/TraceMachina/nativelink.git --rev ae0c82c0 nativelink

# Install build dependencies
# General: clang, lld, libssh2-devel (requires epel-release)
# crates-pro: Python 3.8.19 and pip packages
# performance-benchmark: fontconfig-devel
RUN curl -O https://www.python.org/ftp/python/3.8.19/Python-3.8.19.tgz \
    && tar -xzf Python-3.8.19.tgz \
    && cd Python-3.8.19 \
    && ./configure --enable-optimizations --prefix=/usr/local \
    && make -j8 \
    && make install \
    && cd .. \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install nest_asyncio pexpect requests pytest httpx cython==3.0.10 sphinx myst_parser sphinx_panels sphinx_rtd_theme numpy==1.19.5 torch==1.10.2 dgl==1.0.4 ogb pandas==0.25.3 \
    && rm -rf Python-3.8.19.tgz Python-3.8.19
RUN yum install -y epel-release
RUN yum install -y clang lld fontconfig-devel libssh2-devel

WORKDIR /workdir

# # Install performance-benchmark test/runtime dependencies
# RUN curl -O https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz \
#     && tar -xzf Python-3.11.9.tgz \
#     && cd Python-3.11.9 \
#     && ./configure --enable-optimizations --prefix=/opt \
#     && make -j8 \
#     && make install \
#     && cd .. \
#     && /opt/bin/python3 -m pip install --upgrade pip \
#     && /opt/bin/python3 -m pip install kaleido matplotlib plotly \
#     && rm -rf Python-3.11.9.tgz Python-3.11.9
# RUN ln -s /opt/bin/python3 /usr/local/bin/python
