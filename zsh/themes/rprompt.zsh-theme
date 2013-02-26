###
# Prompt
###
setopt prompt_subst # enable to set escape sequence
# バージョン管理システム
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
vcs_info 2>/dev/null 1>/dev/null
RET=$?
if [[ "$RET" == 0  ]] ; then
    call_vcs_info () {
    LANG=C vcs_info
    # バージョン管理下ならpsvar[1]に代入
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_" 
  }
else
  call_vcs_info () {
  }
fi
precmd () {
  psvar=()
  call_vcs_info
  # local::libを利用していたらpsvar[2]に代入
  [[ -n "$PERL_LOCAL_LIB_ROOT" ]] && psvar[2]="$PERL_LOCAL_LIB_ROOT"
}
# %1(v|%F{green}%1v%f|)        : psvar[1]が存在すればgreenで表示
# %2(v|%F{magenta}%2v%f|)'     : psvar[2]が存在すればmagentaで表示
# %2(v|%F{magenta}(%2v%)%f |)' : 表示を'(psvar[2]) 'にしたバージョン
# %F{}%f                       : %fまでを%F{フォーマット指定}したフォーマットで表示
RPROMPT='%{[m%}%1(v|%F{green}%1v%f|)%2(v|%F{magenta}(locallib:%2v%)%f|)'
