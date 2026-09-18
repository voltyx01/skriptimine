#!/bin/bash
for kasutaja in $(cut -d: -f1 /etc/passwd); do
    echo "Kasutaja: $kasutaja"
done
