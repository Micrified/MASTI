#!/bin/bash

inputDomainList=domainListTestSmall.tsv

for i in `seq 1 5`;
do
## this puts all the searched domains from the inputted domain list
tld=$(sed "${i}q;d" ../tld.txt)
cat $inputDomainList | grep .$tld. >> TLDSep/dot$tld.txt
touch Results/resultdot$tld.txt
done

## Here you can select how many of the selected resolvers you want to be using
for j in `seq 1 16`;
do 
    resolver=$(sed "${j}q;d" dohresolvers.txt)
    for FILE in Results/*.txt
    do  
        echo Resolver: $resolver >> ${FILE}
    done
    ##This is the acutal line that returns how many ms it takes to find a query (only works if it has dnssec flag which is "ad")
    for i in `seq 1 5`;
    do
        ## this puts all the searched domains from the inputted domain list
        tld=$(sed "${i}q;d" ../tld.txt)
        while read line; do 
            set -- $line 
            ./doh $1 $j  >> Results/resultdot$tld.txt
        done < "TLDSep/dot$tld.txt"
    done
    echo -e "\n" >> Results/resultdot$tld.txt
done    
