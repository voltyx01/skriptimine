generate_lottery_numbers() {
    local lottery_file="$1"
    local count=1
    local lottery_number

    echo
    echo "Loosin võidunumbrid..."

    while [ "$count" -le 5 ]; do
        lottery_number=$((RANDOM % 50 + 1))

        if grep -qx "$lottery_number" "$lottery_file"; then
            continue
        fi

        echo "$lottery_number" >> "$lottery_file"
        count=$((count + 1))
    done
}

check_matches() {
    local player_file="$1"
    local lottery_file="$2"
    local number

    matches=0

    echo
    echo "Tulemuste kontrollimine:"
    echo

    while read -r number; do
        echo "Kontrollin numbrit $number..."

        if grep -qx "$number" "$lottery_file"; then
            echo "TABAMUS!"
            matches=$((matches + 1))
        else
            echo "Ei tabanud."
        fi

        echo
    done < "$player_file"
}
