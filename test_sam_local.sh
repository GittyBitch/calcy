#!/bin/bash

cd lambda && sam local invoke --event ../test_payload.json
