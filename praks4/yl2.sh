#!/bin/bash
# Скрипт рассчитывает необходимое количество автобусов для пассажиров

read -p "Sisesta reisijate arv: " reisijad
read -p "Sisesta kohtade arv bussis: " kohad

bussid=$((reisijad / kohad))
jaak=$((reisijad % kohad))

if [ $jaak -gt 0 ]; then
    bussid=$((bussid + 1))
fi

echo "Kokku on vaja $bussid bussi"
