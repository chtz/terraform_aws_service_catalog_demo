#!/bin/bash

aws cloudformation update-stack --stack-name demobucket --template-body file://consumer.yaml
