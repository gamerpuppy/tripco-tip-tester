#!/usr/bin/env bash

if [ ${#} -lt 1 ]; then
    echo usage: ./tip-tester.sh http://host:port
    exit 1
fi
SERVER=${1}

if [ ${#} -e 2 ]; then
	if [[ ${2} == *'distance'* ]]; then
		ENDPOINT='/api/distance'
	fi
	if [[ ${2} == *'itinerary'* ]]; then
		ENDPOINT='/api/itinerary'
	fi
	if [[ ${2} == *'find'* ]]; then
		ENDPOINT='/api/find'
	fi

	cat $2 | python3 json_tool.py ${SERVER} ${ENDPOINT}
	exit 0
fi

echo "testing ${SERVER}"

#rm -rf ./responses/*

echo "config"
python3 json_tool.py ${SERVER} /api/config > ./responses/config_response.json
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

 cat ./requests/${FILENAME} \
    | python3 json_tool.py ${SERVER} ${ENDPOINT} \
    > ./responses/${RESP_FILENAME}

    diff ./expected/${EXPECT_FILENAME} ./responses/${RESP_FILENAME}

done
