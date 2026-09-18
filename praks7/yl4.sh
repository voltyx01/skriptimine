#!/bin/bash

read -p "Sisesta ridade arv: " rida

for (( i=1; i<=rida; i++ )); do
    echo -n "$i. "
    for (( j=1; j<=i; j++ )); do
        echo -n "* "
    done
    echo ""
done
