#!/bin/bash

# Deleting every argument
# SPECIFYING PATH TO FILE WILL ALSO DELETE IT
#for item in "$@"; do
#    rm -rfv "$(readlink -e "$item")";
#done

#rm -rfv '/home/nika/git/MASTI/NormalDNS/TLDsep';
#rm -rfv '/home/nika/git/MASTI/NormalDNS/Results';

cd Results
rm *.txt
