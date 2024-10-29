#!/bin/zsh

#? resolve a short urls destination, printing each hop

function reveal() {
    local url="$1"
    local max_redirects=10
    local redirect_count=0

    while [[ $redirect_count -lt $max_redirects ]]; do
        if [[ $redirect_count -eq 0 ]]; then
            echo "$url"
        fi
        local response=$(curl -sI "$url")
        local status_code=$(echo "$response" | awk '/^HTTP\// {print $2}')
        local location=$(echo "$response" | awk -F': ' '/^[Ll]ocation: / {print $2}')

        if [[ -n "$response" ]]; then
            echo "$status_code $location"
            echo "$response"
            if [[ -n "$location" ]]; then
                url="$location"
            else
                case $status_code in
                    200|204|301|302|307|308)
                        echo c($url)
                        break
                        ;;
                    *)
                        echo "❌ Missing or invalid response, status code: $status_code)." >&2
                        break
                        ;;
                esac
            fi
        else
            echo "\033[0;36m$url\033[0m"
            break
        fi

        ((redirect_count++))
    done

    if [[ $redirect_count -eq $max_redirects ]]; then
        echo "Error: Too many redirects. Aborting." >&2
    fi
}

# #!/bin/zsh

# #? resolve a short urls destination

# function reveal() {
#     curl -sI $1 | grep -i location | awk '{print "\n"$2}'
# }
