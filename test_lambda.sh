#!/bin/bash
aws lambda invoke --function-name calculator_lambda  --cli-binary-format raw-in-base64-out --payload file://test_payload.json response.json


