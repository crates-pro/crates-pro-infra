#!/bin/bash
set -ex

kubectl apply -f deployment.yaml -n docker-registry
