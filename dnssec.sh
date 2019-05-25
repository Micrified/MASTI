#!/bin/bash

inputDomainList=domainListTestSmall.tsv

## this puts all the searched domains from the inputted domain list
cat $inputDomainList | grep .com. >> dotcom.txt
cat $inputDomainList | grep .net. >> dotnet.txt
cat $inputDomainList | grep .br. >> dotbr.txt
cat $inputDomainList | grep .nl. >> dotnl.txt
cat $inputDomainList | grep .ca. >> dotca.txt


## This funciton gets the IPs from the dns_resolvers
while read line; do
  ip="$(grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' <<< "$line")"
  echo "$ip" >> dns_resolversIP.txt
done < "dns_resolvers"

## Here you can select how many of the selected resolvers you want to be using
for i in `seq 1 2`;
do 
    resolver=$(sed "${i}q;d" dns_resolversIP.txt)
    while read line; do 
        ##This is the acutal line that returns how many ms it takes to find a query (only works if it has dnssec flag which is "ad")
        dig @$resolver $line + dnssec +multi  | pcregrep -M "flags:(.*)ad(.|\n)*Query time:.*" | | grep time | grep -Eo '[0-9]{1,}' >> DNSSECResults.txt
    done < "dotnl.txt"
done    
