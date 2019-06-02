declare -A RESOLVERS;

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

function perform_test()
{
    local queries_path="$(readlink -e "$1")";

    local ip='';
    local result_line='';
    declare -a measurements=();
    echo "DNS resolver,Min(ms),Average(ms),Max(ms)";
    for ip in "${!RESOLVERS[@]}"; do
        result=$(./flame -f $queries_path -P tcptls -p 853 "$ip" -n 1 -c 1 -Q 100 | grep "min/avg/max"  | grep -Po -m1 "[\d+\.\d+/?]+ms" | sed 's/ms//' | sed 's/\//,/g')
        echo "${RESOLVERS[$ip]},$result"
    done
}

RESOLVERS_PATH="$1"; shift 1;
QUERIES_PATH="$1";   shift 1;

mkdir -p Results

load_resolvers "$RESOLVERS_PATH";
perform_test "$QUERIES_PATH";