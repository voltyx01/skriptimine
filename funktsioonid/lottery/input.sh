read_player() {
    read -p "Sisesta mängija nimi: " player_name

    if [ -z "$player_name" ]; then
        player_name="Unknown"
    fi
}

read_player_numbers() {
    local player_file="$1"
    local count=1
    local number

    echo
    echo "Sisesta 5 erinevat numbrit vahemikus 1-50."

    while [ "$count" -le 5 ]; do
        read -p "Sisesta number $count: " number

        if [ -z "$number" ]; then
            echo "Viga: number jäi sisestamata."
            continue
        fi

        if ! [[ "$number" =~ ^[0-9]+$ ]]; then
            echo "Viga: sisesta täisarv."
            continue
        fi

        if [ "$number" -lt 1 ] || [ "$number" -gt 50 ]; then
            echo "Viga: number peab olema vahemikus 1-50."
            continue
        fi

        if grep -qx "$number" "$player_file"; then
            echo "Viga: see number on juba valitud."
            continue
        fi

        echo "$number" >> "$player_file"
        count=$((count + 1))
    done
}
