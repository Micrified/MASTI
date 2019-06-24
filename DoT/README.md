# DoT

<<<<<<< HEAD
 Based on the flamethrower application at [link](https://github.com/DNS-OARC/flamethrower).
=======
 Uses the flame(thrower) application at [link](https://github.com/DNS-OARC/flamethrower) with supplied domains and resolvers. Flame is prebuild and the binary is given in the folder. If for whatever reason it doesn't work you can try to build it yourself by going to their repository.
 
 The flame binary is used in this script with multiple parameters:
  * -f: followed by a file with domains to be resolved
  * -P: followed by the string tcptls to tell it to perform DoT
  * -p: followed by 853 to indicate to use the DoT port
  * -n: followed by 1 to go through the domain file once
  * -c: followed by 1 to use only 1 packet generator (in line with other tools)
  * -Q: followed by 10 to rate limit it to 10 packets per second (in line with other tools)
>>>>>>> 748abda2665e624d41c8041d7a3835816f5146f3

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
1. Get `autopoint`: `sudo apt-get install autopoint`
2. Get `libtirpc` [here](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/libtirpc.html) by downloading and following the make and install instructions exactly. You may need to add some more `sudo` between their `&&`'d commands though.
3. Get `rpcsvc-proto-1.4` [here](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/rpcsvc-proto.html) by downloading and following the make and install instructions exactly. You may need to add some more `sudo` between their `&&`'d commands though.
4. Get `libnsl` [here](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/libnsl.html) by downloading and following the instructions for make and install. As usual do them exactly as specified. You may need to add some more `sudo` between their `&&`'d commands though.
5. Use `apt-get` to acquire `libldns` as follows: `sudo apt-get install libldns-dev`


## Copy paste instruction for Ubuntu
```
sudo add-apt-repository ppa:acooks/libwebsockets6
sudo apt-get update
sudo apt-get install autopoint bzip2 make libuv1.dev
mkdir -p ~/Downloads
cd ~/Downloads/
wget https://downloads.sourceforge.net/libtirpc/libtirpc-1.1.4.tar.bz2
tar -xvjf libtirpc-1.1.4.tar.bz2
cd libtirpc-1.1.4/
./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --disable-static                                \
            --disable-gssapi                                &&
make
sudo make install &&
sudo mv -v /usr/lib/libtirpc.so.* /lib &&
sudo ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so
cd ~/Downloads
wget https://github.com/thkukuk/rpcsvc-proto/releases/download/v1.4/rpcsvc-proto-1.4.tar.gz
tar -xvzf rpcsvc-proto-1.4.tar.gz
cd rpcsvc-proto-1.4/
./configure --sysconfdir=/etc && make
sudo make install
cd ~/Downloads
wget https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz
tar -xvzf libnsl-1.2.0.tar.gz
cd libnsl-1.2.0/
autoreconf -fi                &&
./configure --sysconfdir=/etc &&
make
sudo make install                  &&
sudo mv /usr/lib/libnsl.so.2* /lib &&
sudo ln -sfv ../../lib/libnsl.so.2.0.0 /usr/lib/libnsl.so
sudo apt-get install libldns-dev
```


## Usage

<<<<<<< HEAD
    DoT.sh path_to_resolvers path_to_queries
=======
    DoT.sh path_to_resolvers_FILE path_to_queries_FOLDER
>>>>>>> 748abda2665e624d41c8041d7a3835816f5146f3

    resolvers is a space-delimeted file with ip-name combinations
    queries is a space-delimeted file with query-querytype combinations

## Examples

<<<<<<< HEAD
    $ ./DoT.sh dns_resolvers.txt domainListTestSmall.tsv
    $ ./DoT.sh dns_resolvers.txt ../LiveDomains/dotau.txt
=======
    $ ./DoT.sh dns_resolvers.txt ./domains/
    $ ./DoT.sh dns_resolvers.txt ../LiveDomains/
>>>>>>> 748abda2665e624d41c8041d7a3835816f5146f3
