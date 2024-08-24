# File: ~/.config/zsh/source_completions
# Description: It just sources all the generated completion scripts from various programs that I use.
#
# Written by: Glozzom

source_completion_scripts() {
    local completions="$1"

    if [[ ! -d "$completions" ]]; then
        echo "Completion directory does not exist: $completions"
        return 1 
    fi 

    for file in "$completions"/*;
    do
        if [[ -f $file && -r $file ]]; then
            if zsh -n "$file" 2>/dev/null; then
                source $file
            else
                echo "skipping $file (not a valid zsh script)"
            fi
        fi
    done
    
}
