#!/bin/bash/

# return CUDA ID with the maximum free memory
function maxFreeMemCUDA() {
    prefix="memory.free\[MiB\]"
    # echo $prefix
    mem_free=$(nvidia-smi --query-gpu=memory.free --format=csv | tr -d '\n' | tr -d ' ' | sed -e "s/^$prefix//")
    mem_free_list="${mem_free//MiB/,}"   # string like num1,num2,num3,
    # echo "$mem_free_list"
    oldIFS=$IFS
    IFS=','
    idx=0
    max_idx=-1
    max_mem=0
    for cur_mem in $mem_free_list
    do
    # echo $idx $cur_mem

    if (( max_mem  < cur_mem ))
        then
        max_mem=$cur_mem
        max_idx=$idx
    fi 

    let idx++
    done
    # echo "Max memory: $max_mem; CUDA ID: $max_idx"

    IFS=$oldIFS
    echo $max_idx
}

# nvidia-smi --query-gpu=memory.free --format=csv
res=$(maxFreeMemCUDA)
echo "Max cuda ID: $res"