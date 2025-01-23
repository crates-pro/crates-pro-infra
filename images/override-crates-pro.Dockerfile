ARG BASE_IMAGE
FROM $BASE_IMAGE

##### Override project files for 'crates-pro' (see '[crates-pro-infra]/images/base.Dockerimage')
RUN rm -rf ./project/crates-pro
# source directories
COPY ./analysis             ./project/crates-pro/analysis
COPY ./crates_pro           ./project/crates-pro/crates_pro
COPY ./data_transporter     ./project/crates-pro/data_transporter
COPY ./model                ./project/crates-pro/model
COPY ./repo_import          ./project/crates-pro/repo_import
COPY ./search               ./project/crates-pro/search
COPY ./tudriver             ./project/crates-pro/tudriver
# source files
COPY ./BUCK                 ./project/crates-pro/BUCK
COPY ./.env                 ./project/crates-pro/.env
