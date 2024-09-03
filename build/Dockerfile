FROM --platform=linux/amd64 almalinux:8.10-20240723

# Install tools and dependencies
# Kafka: java-11-openjdk
# pip: openssl-devel
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y curl java-11-openjdk openssl-devel

# Install crates-pro test/runtime dependencies
ENV KAFKA_VERSION=3.8.0
ENV SCALA_VERSION=2.13
ENV KAFKA_HOME=/opt/kafka
RUN curl -O https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
    mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} $KAFKA_HOME && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

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

COPY crates-pro/crates_pro .
COPY crates-pro/.env .

# Required by //crates-pro/src/main.rs
RUN mkdir target

CMD ["./crates_pro"]
