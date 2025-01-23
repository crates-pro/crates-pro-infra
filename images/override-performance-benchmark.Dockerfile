ARG BASE_IMAGE
FROM $BASE_IMAGE

##### Override project files for 'performance-benchmark' (see '[crates-pro-infra]/images/base.Dockerimage')
RUN rm -rf ./project/performance-benchmark
# source directories
COPY project/performance-benchmark/collector    ./project/performance-benchmark/collector
COPY project/performance-benchmark/data_manage  ./project/performance-benchmark/data_manage
# source files
COPY project/performance-benchmark/BUCK     ./project/performance-benchmark/BUCK
