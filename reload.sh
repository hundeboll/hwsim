#!/bin/bash


nodes=(1 2)

for n in ${nodes[@]}; do
    ./unload.sh $n
done

./unload.sh

for n in ${nodes[@]}; do
    ./load.sh $n;
done
