function peco-select-history() {
    local tac
    if whence -p tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
		grep -vE '^(cd|ls$|fg$|vim$)' |
		awk '!a[$0]++' | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
#    zle clear-screen
}
zle -N peco-select-history
