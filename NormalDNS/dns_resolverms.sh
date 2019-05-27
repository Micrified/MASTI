#!/bin/bash

declare -A RESOLVERS;

function load_resolvers()
{
    local path="$1"; shift 1;

    local line='';
    local key='';
    local value='';

    while read line
    do
	key="$(echo "$line" | grep -Po '^[^\s]+';)";
	value="$(echo "$line" | grep -Po '(?<=\s).*$';)";
	RESOLVERS["$key"]="$value";
    done  < "$(readlink -e "$path")"
}

function perform_test()
{
    local queries_path="$(readlink -e "$1")";

    local ip='';
    local result_line='';
    declare -a measurements=();

    echo "DNS resolver,Average(ms),Min(ms),Max(ms)";
    for ip in "${!RESOLVERS[@]}"; do

	result_line="$(
	    dnsperf -d "$queries_path" -s "$ip" | grep -i 'average latency';
	)";
	readarray -t measurements < <(echo "$result_line" | grep -Po '[\.\d]+';);
	
	measurements[0]="$(echo "${measurements[0]} * 1000" | bc)";
	measurements[1]="$(echo "${measurements[1]} * 1000" | bc)";
	measurements[2]="$(echo "${measurements[2]} * 1000" | bc)";

	echo "${RESOLVERS[$ip]},${measurements[0]},${measurements[1]},${measurements[2]}";
    done
}

RESOLVERS_PATH="$1"; shift 1;
QUERIES_PATH="$1";   shift 1;

load_resolvers "$RESOLVERS_PATH";
perform_test   "$QUERIES_PATH";
