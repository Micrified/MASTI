declare -A RESOLVERS;
declare -A QUERIES_FILES;

inputDomainList=domainListTestSmall.tsv



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
            basename "$query_filepath" | grep -Po '(?<=^dot).*?(?=\.)';
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
    declare -a measurements=();
    echo "DNS resolver,Min(ms),Average(ms),Max(ms)";
    for ip in "${!RESOLVERS[@]}"; do
        result=$(./flame -f $query_path -P tcptls -p 853 "$ip" -n 1 -c 1 -Q 100 | grep "min/avg/max"  | grep -Po -m1 "[\d+\.\d+/?]+ms" | sed 's/ms//' | sed 's/\//,/g')
        echo "${RESOLVERS[$ip]},$result"
    done
}

RESOLVERS_PATH="$1"; shift 1;
QUERIES_PATH="$1";   shift 1;

mkdir -p Results

load_resolvers "$RESOLVERS_PATH";
load_queries   "$QUERIES_PATH";

for TLD in "${!QUERIES_FILES[@]}"; do
    perform_test "$TLD" "${QUERIES_FILES[$TLD]}";
done