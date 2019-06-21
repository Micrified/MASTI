# MASTI
Measuring and Simulating the Internet 

# Statistics
Our domain list is from https://www.dns-oarc.net/tools/dnsperf, that contains 10,000,000 registerred domains, from different nations.
Our initial step was to filter out 5 interesting top level domains
* COM (4893877) 
* AU (33510)
* NET (1741547)
* NL (11598)
* CA (19403)

This sums up to about 6.7M domains which would give us about a 67% coverage of the whole list. 

However, not all domains are still alive. Thus we had to filter out to have only the ones that actually return a live address. From those that are alive, we took 1000 subdomains out and ran the test on these 5000 domains. 

# List of all dependencies for Ubuntu/Debian
```
sudo apt-get install -y libbind-dev libkrb5-dev libssl-dev libcap-dev libxml2-dev libjson-c-dev libgeoip-dev autoconf libtool install -y libprotobuf-c-dev libfstrm-dev liblmdb-dev dnsutils pcregrep libcurl4-openssl-dev make autopoint
```
