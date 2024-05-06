#!/bin/zsh

#? shallow clone a repo and open in vscode

peep() {
    local repo=$1
    local repo_name=$(basename $repo)

    mkdir -p ~/dev/peep
    gh repo clone $repo ~/dev/peep/$repo_name -- --depth=1
    code ~/dev/peep/$repo_name
}
