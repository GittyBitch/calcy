#!/bin/bash
curl -f -s -X POST "$1/calc" -H "Content-Type: application/json" -d @test_payload.json && \
echo "Updating HTML combo for new API gateway" && \
sed "0,/_NONE_/s##$1/calc#" data.js.template > html/data.js && \
sed -i "0,/AKTUELL/s##$(whoami)#" html/data.js
