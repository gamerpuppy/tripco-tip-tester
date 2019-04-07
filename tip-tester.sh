#!/usr/bin/env bash

SERVER=$1

echo "testing ${SERVER}"

#rm -rf ./responses/*

echo "config"
python3 json_tool.py ${SERVER} /api/config || exit 1 > ./responses/config_response.json
diff ./expected/config_expect.json ./responses/config_response.json

for FILENAME in $(ls ./requests)
do
    if [[ ${FILENAME} == *'distance'* ]]; then
        ENDPOINT='/api/distance'
    fi
    if [[ ${FILENAME} == *'itinerary'* ]]; then
        ENDPOINT='/api/itinerary'
    fi
    if [[ ${FILENAME} == *'find'* ]]; then
        ENDPOINT='/api/find'
    fi

    echo ${FILENAME}

    RESP_FILENAME="${FILENAME%.json}_response.json"
    EXPECT_FILENAME="${FILENAME%.json}_expect.json"

#    cat ./requests/${FILENAME} \
#    | python3 json_tool.py ${SERVER} ${ENDPOINT} \
#        > ./responses/${RESP_FILENAME}

 cat ./requests/${FILENAME} \
    | python3 json_tool.py ${SERVER} ${ENDPOINT} \
    > ./responses/${RESP_FILENAME}

    diff ./expected/${EXPECT_FILENAME} ./responses/${RESP_FILENAME}

done