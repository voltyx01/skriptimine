#!/bin/bash
touch a.txt b.txt c.txt

for fail in *.txt; do
    echo "Fail: $fail"
done
