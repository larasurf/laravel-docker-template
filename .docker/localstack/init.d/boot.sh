#!/bin/bash

awslocal cloudformation create-stack \
    --stack-name "app" \
    --template-body "file:///docker-entrypoint-initaws.d/app.yml"
