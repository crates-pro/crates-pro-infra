FROM tugraph/tugraph-compile-centos8:1.3.4

# Install Rust with nightly-2024-11-23 toolchain (as in NativeLink `MODULE.bazel`)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2024-11-23 -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install NativeLink
RUN cargo install --git https://github.com/TraceMachina/nativelink.git --rev 7afe2868 nativelink

# Install build dependencies
# General: clang, lld, libssh2-devel (requires epel-release)
# crates-pro: Python 3.8.20 and pip packages
# performance-benchmark: fontconfig-devel
RUN curl -O https://www.python.org/ftp/python/3.8.20/Python-3.8.20.tgz \
    && tar -xzf Python-3.8.20.tgz \
    && cd Python-3.8.20 \
    && ./configure --enable-optimizations --prefix=/usr/local \
    && make -j8 \
    && make install \
    && cd .. \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install nest_asyncio pexpect requests pytest httpx cython==3.0.10 sphinx myst_parser sphinx_panels sphinx_rtd_theme numpy==1.19.5 torch==1.10.2 dgl==1.0.4 ogb pandas==0.25.3 \
    && rm -rf Python-3.8.20.tgz Python-3.8.20
RUN yum install -y epel-release \
    && yum install -y clang lld fontconfig-devel libssh2-devel

WORKDIR /workdir

# Download resources required by `//third-party/vendor/utoipa-swagger-ui-9.0.0-patch1/src/lib.rs`
RUN curl -L -o swagger-ui-5.17.14.zip https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip \
    && unzip -j swagger-ui-5.17.14.zip "swagger-ui-5.17.14/dist/*" -d ./swagger-ui-5.17.14-dist \
    && rm -f swagger-ui-5.17.14.zip

COPY basic_cas.json5 .
CMD ["nativelink", "./basic_cas.json5"]
