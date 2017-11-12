#!/bin/bash
# My first script

#echo -n "Dummy command to see how echo works"
#get only the 'Measurement Result' data
cd "./raw_data_process_1/"
number=1
#total number of files
declare -i filenumber
declare -i fn
filenumber=21
while [ $number -lt $filenumber ]; do
    f1="f${number}.txt"
    f2="f${number}_new.txt"
    grep 'Measurement Result'  $f1 > $f2
    number=$((number + 1))
done

#generate a single csv that contains all the data
#matlab -nojvm < get_csv(filenumber)
matlab -nodisplay -nojvm -r "get_csv($filenumber-1);exit;"
sed 1d *.csv > merged.csv
#matlab -nojvm < get_merged_data_matrix.m
cd "../"






