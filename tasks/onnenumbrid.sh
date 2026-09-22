#!/bin/bash

# Проходим по всем числам от 1000 до 9999
for ((algne_arv=1000; algne_arv<=9999; algne_arv++)); do
    arv=$algne_arv
    
    # Повторяем сложение цифр, пока результат не станет однозначным
    while [ $arv -gt 9 ]; do
        summa=0
        temp=$arv
        
        # Выделяем цифры и считаем их сумму
        while [ $temp -gt 0 ]; do
            viimane_number=$((temp % 10))
            summa=$((summa + viimane_number))
            temp=$((temp / 10))
        done
        
        arv=$summa
    done
    
    # Если результат равен 7, выводим исходное число
    if [ $arv -eq 7 ]; then
        echo $algne_arv
    fi
done
