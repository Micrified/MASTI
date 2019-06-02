#!/bin/bash

declare -A RESOLVERS;
declare -A QUERIES_FILES;

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

function load_queries()
{
    local queries_dir="$(readlink -e "$1")"; shift 1;

    local query_filepath='';
    local query_tld='';

    for query_filepath in ${queries_dir}/*; do
	query_tld="$(
            basename "$query_filepath" \
                | grep -Po '(?<=^dot).*?(?=\.)';
        )";

	if [ -n "$query_tld" ];then
	    QUERIES_FILES["$query_tld"]="$query_filepath";
	fi
    done
}

function perform_test()
{
    local tld="$1";        shift 1;
    local query_path="$1"; shift 1;

    local ip='';
    local result_line='';
    local results_dir="$(dirname $(readlink -e "$0"))/Results";
    declare -a measurements=();

    mkdir -pv "$results_dir";

    for ip in "${!RESOLVERS[@]}"; do
    	result_line="$(
    	    dnsperf -d "$query_path" -s "$ip" | grep -i 'average latency';
    	)";
    	readarray -t measurements < <(
    	    echo "$result_line" | grep -Po '[\.\d]+';
    	);

    	measurements[0]="$(echo "${measurements[0]} * 1000" | bc)";
    	measurements[1]="$(echo "${measurements[1]} * 1000" | bc)";
    	measurements[2]="$(echo "${measurements[2]} * 1000" | bc)";

    	echo "${RESOLVERS[$ip]},${measurements[1]},${measurements[0]},${measurements[2]}" >> "${results_dir}/resultdot${tld}.csv";

    done
}



#################-| MAIN |-#################

RESOLVERS_PATH="$1"; shift 1;
QUERIES_DIR="$1";    shift 1;

load_resolvers "$RESOLVERS_PATH";
load_queries   "$QUERIES_DIR";

for TLD in "${!QUERIES_FILES[@]}"; do
    perform_test "$TLD" "${QUERIES_FILES[$TLD]}";
done
