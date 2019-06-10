#!/bin/bash

#inputDomainList=domainListTestSmall.tsv

for i in `seq 1 5`;
do
## this puts all the searched domains from the inputted domain list
tld=$(sed "${i}q;d" ../tld.txt)
#cat $inputDomainList | grep .$tld.$(printf '\t') >> TLDSep/dot$tld.txt
touch Results/resultdot$tld.txt
done


## This funciton gets the IPs from the dns_resolvers
# while read line; do
#   ip="$(grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' <<< "$line")"
#   echo "$ip" >> ../dns_resolversIP.txt
# done < "../dns_resolvers.txt"

## Here you can select how many of the selected resolvers you want to be using
for k in `seq 1 6`;
do 
    resolver=$(sed "${k}q;d" ../dns_resolversIP.txt)
    for FILE in Results/*.txt
    do  
        echo Resolver: $resolver >> ${FILE}
    done
    ##This is the acutal line that returns how many ms it takes to find a query (only works if it has dnssec flag which is "ad")
    for j in `seq 1 5`;
    do
        ## this puts all the searched domains from the inputted domain list
        tld=$(sed "${j}q;d" ../tld.txt)
        while read line; do 
            dig @$resolver $line + dnssec +multi  | pcregrep -M "flags:(.*)ad(.|\n)*Query time:.*" | grep time | grep -Eo '[0-9]{1,}' >> Results/resultdot$tld.txt
        done < "../LiveDomains/dot$tld.txt"
    done
    echo -e "\n" >> Results/resultdot$tld.txt
done    

for i in `seq 1 5`;
do
## this puts all the searched domains from the inputted domain list
tld=$(sed "${i}q;d" ../tld.txt)
echo -e "Resolver:" >> Results/resultdot$tld.txt
done
