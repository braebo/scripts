#!/bin/zsh

for script in $HOME/dev/scripts/shell/*.sh; do
    case "$script" in
    *template.sh) ;; # Skip template files
    *) source $script ;;
    esac
done
