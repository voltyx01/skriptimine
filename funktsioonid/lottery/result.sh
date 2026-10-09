show_header() {
    echo "LOTOMÄNG"
    echo
}

show_player_numbers() {
    local player_file="$1"

    echo
    echo "Mängija valitud numbrid:"
    cat "$player_file"
}

show_lottery_numbers() {
    local lottery_file="$1"

    echo
    echo "Võidunumbrid:"
    cat "$lottery_file"
}

set_result() {
    local match_count="$1"

    if [ "$match_count" -eq 5 ]; then
        result="JACKPOT!"
    elif [ "$match_count" -eq 4 ]; then
        result="Väga hea tulemus!"
    elif [ "$match_count" -eq 3 ]; then
        result="Hea tulemus."
    elif [ "$match_count" -eq 2 ]; then
        result="Kaks tabamust."
    elif [ "$match_count" -eq 1 ]; then
        result="Üks tabamus."
    else
        result="Seekord tabamusi ei olnud."
    fi
}

show_result() {
    local player="$1"
    local match_count="$2"
    local game_result="$3"

    echo "Mängija: $player"
    echo "Tabamusi: $match_count / 5"
    echo "$game_result"
}
