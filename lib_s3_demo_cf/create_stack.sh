#!/bin/bash

aws cloudformation create-stack --stack-name demobucket --template-body file://consumer.yaml
