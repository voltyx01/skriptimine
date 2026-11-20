#!/bin/bash
# php paigaldusskript
#
# kontrollime, mitu korda "ok installed" leitakse ja salvestame muutujasse
PHP=$(dpkg-query -W -f='${Status}' php 2>/dev/null | grep -c 'ok installed')

# kui PHP muutuja väärtus võrdub 0-ga
if [ "$PHP" -eq 0 ]; then
    # siis ok installed ei ole leitud, väljastame teate ja paigaldame teenuse
    echo "Paigaldame php ja vajalikud lisad"
    apt update
    apt install -y php libapache2-mod-php php-mysql
    # konfiguratsioon: taaskäivitame apache, et php moodul laaditaks
    if systemctl list-unit-files | grep -q '^apache2.service'; then
        systemctl restart apache2
    fi
    echo "php on paigaldatud"
# kui PHP muutuja väärtus võrdub 1-ga
elif [ "$PHP" -eq 1 ]; then
    # siis teenus on juba paigaldatud
    echo "php on juba paigaldatud"
    # kontrollime olemasolu
    which php
fi
# skripti lõpp
