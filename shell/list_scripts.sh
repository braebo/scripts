#!/bin/zsh

#? list available local scripts

function list_scripts() {
    echo "|--------------|-------------------------------------------------------------|"

    for script in ~/dev/scripts/shell/*.sh; do
        if [[ -f "$script" ]]; then
            script_name=${script##*/}
            function_name=${script_name%.sh}
            description=$(awk 'BEGIN { skip=1; firstComment=1 }
                /^#!/ { next }
                /^#/ && firstComment { print substr($0, 3); firstComment=0; exit }' "$script")

            # Use printf to control column widths
            printf "| %-12s | %-50s |\n" "$function_name" "$description"
        fi
    done

    return
}
