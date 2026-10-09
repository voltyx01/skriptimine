clear_files() {
    local player_file="$1"
    local lottery_file="$2"

    > "$player_file"
    > "$lottery_file"
}

save_result() {
    local results_file="$1"
    local player_file="$2"
    local lottery_file="$3"
    local player="$4"
    local match_count="$5"
    local game_result="$6"

    {
        echo "========================================"
        echo "Date: $(date)"
        echo "Player: $player"
        echo "Player numbers:"
        cat "$player_file"
        echo "Lottery numbers:"
        cat "$lottery_file"
        echo "Matches: $match_count"
        echo "Result: $game_result"
    } >> "$results_file"
}
