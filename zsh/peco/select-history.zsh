function peco-select-history() {
    local tac
    if whence -p tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
		ruby -e '$stdin.readlines.uniq.each{|l| print l}' | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
#    zle clear-screen
}
zle -N peco-select-history
