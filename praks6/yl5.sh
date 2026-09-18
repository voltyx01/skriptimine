#!/bin/bash
tekst="koer;kass;hiir"
IFS=';'
for sona in $tekst; do
    echo "$sona"
done
