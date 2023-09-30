#!/bin/bash
curl  -X POST "$1/calc" -H "Content-Type: application/json" -d @test_payload.json 
sed "0,/_NONE_/s##$1/calc#" data.js.template > html/data.js
sed -i "0,/AKTUELL/s##$(whoami)#" html/data.js
