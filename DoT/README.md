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

## Installation on Ubuntu

Installing on Ubuntu only requires a few simple steps. 

1. Get `libtirpc` [here](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/libtirpc.html) by downloading and following the make and install instructions exactly. You may need to add some more `sudo` between their `&&`'d commands though.
2. Get `rpcsvc-proto-1.4` [here](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/rpcsvc-proto.html) by downloading and following the make and install instructions exactly. You may need to add some more `sudo` between their `&&`'d commands though.
3. Get `libnsl` [here](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/libnsl.html) by downloading and following the instructions for make and install. As usual do them exactly as specified. You may need to add some more `sudo` between their `&&`'d commands though.
4. Use `apt-get` to acquire `libldns` as follows: `sudo apt-get install libldns-dev`

## Usage

    DoT.sh path_to_resolvers path_to_queries

    resolvers is a space-delimeted file with ip-name combinations
    queries is a space-delimeted file with query-querytype combinations

## Examples

    $ ./DoT.sh dns_resolvers.txt domainListTestSmall.tsv
    $ ./DoT.sh dns_resolvers.txt ../LiveDomains/dotau.txt
