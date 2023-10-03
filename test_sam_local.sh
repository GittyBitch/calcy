#!/bin/bash
if command -v sam &> /dev/null
then
    #echo '{"sam_available": "true"}'
    cd lambda && sam local invoke --event ../test_payload.json > ../sam_response.json
    jq '.body == "330"' ../sam_response.json
else
    echo '{"sam_available": "false"}'

fi

