#!/bin/bash

#script to get files with only 'Measurement Result'
cd "./data/"
number=1
#total number of files
filenumber=9
while [ $number -lt $filenumber ]; do
    f1="f${number}.txt"
    f2="f${number}_new.txt"
    grep 'Measurement Result'  $f1 > $f2
    number=$((number + 1))
done
