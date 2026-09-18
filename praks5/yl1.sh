#!/bin/bash

echo -n "Sisesta (oma) vanus: "
read vanus

if [ $vanus -ge 0 -a $vanus -lt 11 ]; then
    echo "Oled laps"
elif [ $vanus -ge 11 -a $vanus -lt 18 ]; then
    echo "Oled nooruk"
elif [ $vanus -ge 18 -a $vanus -lt 63 ]; then
    echo "Oled täiskasvanu"
elif [ $vanus -ge 63 ]; then
    echo "Oled senioor"
else
    echo "Vigane sisend"
fi
