#!/bin/zsh

#? print 20 timestamps in the past 48-72 hours


function timestamps() {
    local timestamps=()

    for i in {1..20}; do
        local HOURS=$(($RANDOM % 24 + 48))
        local MINUTES=$(($RANDOM % 60))
        local SECONDS=$(($RANDOM % 60))
        timestamps+=("$(date -v-${HOURS}H -v-${MINUTES}M -v-${SECONDS}S +'%Y-%m-%dT%H:%M:%S')")
    done

    local sorted_timestamps=($(printf "%s\n" "${timestamps[@]}" | sort))

    for ts in "${sorted_timestamps[@]}"; do
        echo "$ts"
    done
}
