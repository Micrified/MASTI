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
    local tld='';
    local result_line='';
    local results_dir="$(dirname $(readlink -e "$0"))/Results";
    local tlds_sep_dir="$(dirname $(readlink -e "$0"))/TLDsep";
    declare -a measurements=();
    declare -a tlds=();

    mkdir -pv "$tlds_sep_dir";
    mkdir -pv "$results_dir";
    
    readarray -t tlds < <(
	grep -Po '(\w+)\.?\s' domainListTestSmall.tsv \
	    | grep -Po '^[a-zA-z\d]+' \
	    | sort -u;
    );

    # echo "DNS resolver,Min(ms,)Average(ms),Max(ms)";
    for tld in "${tlds[@]}"; do
	grep -P "\b${tld}\b\.\s" "$queries_path" >> "${tlds_sep_dir}/dot${tld}.txt";
    done

    for tld in "${tlds[@]}"; do
	for ip in "${!RESOLVERS[@]}"; do
	    result_line="$(
		dnsperf -d "${tlds_sep_dir}/dot${tld}.txt" -s "$ip" | grep -i 'average latency';
            )";	   
            readarray -t measurements < <(
		echo "$result_line" | grep -Po '[\.\d]+';
            );

            measurements[0]="$(echo "${measurements[0]} * 1000" | bc)";
            measurements[1]="$(echo "${measurements[1]} * 1000" | bc)";
            measurements[2]="$(echo "${measurements[2]} * 1000" | bc)";

            echo "${RESOLVERS[$ip]},${measurements[1]},${measurements[0]},${measurements[2]}" >> "${results_dir}/resultdot${tld}.txt";
	done
    done
}

RESOLVERS_PATH="$1"; shift 1;
QUERIES_PATH="$1";   shift 1;

load_resolvers "$RESOLVERS_PATH";
perform_test   "$QUERIES_PATH";
