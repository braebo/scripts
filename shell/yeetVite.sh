#!/bin/zsh

#? kill all running vite processes

function yeetVite() {
    pids=$(ps aux | grep -v grep | grep -i vite | awk '{print $2}')

    if [ -z "$pids" ]; then
        echo "No vite processes found"
        return
    fi

    while read -r pid; do
        echo "Killing process $pid"
        kill -9 "$pid"
    done <<<"$pids"

    echo "vite has been yeeted 👍"
}
