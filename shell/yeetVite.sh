#!/bin/zsh

#? kill all running vite processes

function yeetVite() {
    pids=$(ps aux | grep -v grep | grep -i vite | awk '{print $2}')

    echo "$(b "\n$(ps aux | grep -i vite | grep -v grep | wc -l | tr -d ' ')") $(dim "vite processes found")\n"

    if [ -z "$pids" ]; then
        return
    fi

    while read -r pid; do
        cmd=$(ps -p "$pid" -o args= 2>/dev/null)
        kill -9 "$pid" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "💀 $pid $(dim "$cmd")"
        else
            echo "❌ $pid $(dim "$cmd")"
            echo "$(dim "failed to kill") $pid"
        fi
    done <<<"$pids"

    echo -e "\nyeeted vite 👍"
}
