#!/bin/bash
output_path="../sam_response.json"
if command -v sam &> /dev/null
then
    #echo '{"sam_available": "true"}'
    cd lambda && sam local invoke --event ../test_payload.json > $output_path
    jq '.body == "330"' $output_path
else
    echo '{"sam_available": "false"}'

fi

