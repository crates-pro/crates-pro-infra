ARG BASE_IMAGE
FROM $BASE_IMAGE

##### Override project files for 'sensleak-rs' (see '[crates-pro-infra]/images/base.Dockerimage')
RUN rm -rf ./project/sensleak-rs
# source directories
COPY project/sensleak-rs/src                ./project/sensleak-rs/src
# source files
COPY project/sensleak-rs/BUCK               ./project/sensleak-rs/BUCK
