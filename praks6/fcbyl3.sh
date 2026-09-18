#!/bin/bash
for i in {1..3}; do
    for j in {1..10}; do
        if [[ $j -eq 5 ]]; then
            break 2
        fi
        echo "Väline: $i, Sisemine: $j"
    done
done
