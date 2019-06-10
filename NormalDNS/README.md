# DNSperf
## Building from Git repository

```
git clone https://github.com/DNS-OARC/dnsperf.git
cd dnsperf
./autogen.sh
./configure 
make
make install
```

## Dependencies

`dnsperf` requires a couple of libraries beside a normal C compiling
environment with autoconf, automake, libtool.

`dnsperf` has a non-optional dependency on the BIND library and development
files along with all dependencies it requires.

To install the dependencies under Debian/Ubuntu:
```
apt-get install -y libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev libjson-c-dev libgeoip-dev autoconf libtool
```

Depending on how BIND is compiled on Debian and Ubuntu you might need these
dependencies also:
```
apt-get install -y libprotobuf-c-dev libfstrm-dev liblmdb-dev
```

# DNS Script
To run the Normal DNS script you have to go to the folder that contains the script, the resolvers list and the folder containing the files with TLDs called **LiveDomains** and list them in the same order(see below).

nika@nika-VirtualBox:~/git/MASTI/NormalDNS$ ./dns_resolver.sh dns_resolvers.txt LiveDomains 

The script will create the folder **Results**, where the results for every TLD  will be stored as .csv files. When the run is finished, the output files will be there. To delete the folders and run the script again, use the cleaning script **clean.sh** by specifying the names of the folders that need to be removed - respectively **Results**.
