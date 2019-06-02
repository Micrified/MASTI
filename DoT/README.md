# DoT

 Based on the flamethrower application at [link](https://github.com/DNS-OARC/flamethrower).

Dependencies
------------

* CMake >= 3.5
* Linux or OSX
* libuv >= 1.23.0
* libldns >= 1.7.0
* gnutls >= 3.3
* C++ compiler supporting C++17

## Usage

    DoT.sh path_to_resolvers path_to_queries

    resolvers is a space-delimeted file with ip-name combinations
    queries is a space-delimeted file with query-querytype combinations

## Examples

    $ DoT.sh dns_resolvers.txt domainListTestSmall.tsv
