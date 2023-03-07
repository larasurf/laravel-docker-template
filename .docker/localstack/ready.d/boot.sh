#!/bin/bash

awslocal cloudformation create-stack \
    --stack-name "app" \
    --template-body "file:///etc/localstack/init/ready.d/app.yml"
