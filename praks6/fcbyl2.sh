#!/bin/bash
while true; do
    read -p "Sisesta number (0 lõpetab): " nr
    if [[ $nr -eq 0 ]]; then
        break
    elif [[ $nr -lt 0 ]]; then
        continue
    fi
    echo "Sisestatud arv: $nr"
done
