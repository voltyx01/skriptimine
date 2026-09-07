#!/bin/bash
# Скрипт проверяет, является ли введенное число четным или нечетным

read -p "Sisesta suvaline täisarv: " arv

if [ $((arv % 2)) -eq 0 ]; then
    echo "Antud arv on paaris"
else
    echo "Antud arv on paaritu"
fi
