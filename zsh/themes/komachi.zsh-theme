KOMACHI_BRACKET_COLOR="%{$fg[white]%}"
KOMACHI_PLENV_COLOR="%{$fg[yellow]%}"
KOMACHI_RVM_COLOR="%{$fg[magenta]%}"
KOMACHI_PLENV_COLOR="%{$fg[magenta]%}"
KOMACHI_PERL_LOCALLIB_COLOR="%{$fg[red]%}"
KOMACHI_DIR_COLOR="%{$fg[cyan]%}"
KOMACHI_GIT_BRANCH_COLOR="%{$fg[green]%}"
KOMACHI_GIT_CLEAN_COLOR="%{$fg[green]%}"
KOMACHI_GIT_DIRTY_COLOR="%{$fg[red]%}"

# These Git variables are used by the oh-my-zsh git_prompt_info helper:
ZSH_THEME_GIT_PROMPT_PREFIX="$KOMACHI_BRACKET_COLOR:$KOMACHI_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" $KOMACHI_GIT_CLEAN_COLOR✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $KOMACHI_GIT_DIRTY_COLOR✗"

# Our elements:

_get_rubyversion () {
	local rubyversion
	if [ -e ~/.rvm/bin/rvm-prompt ]; then
		rubyversion=${$(~/.rvm/bin/rvm-prompt i v g)#ruby-}
	else
		if which rbenv &> /dev/null; then
			rubyversion=$(rbenv version | sed -e 's/ (set.*$//' -e 's/^ruby-//')
		fi
	fi
	echo $rubyversion
}
_get_perlversion () {
	local perlversion
	if which perlbrew &> /dev/null; then
		perlversion=$(perlbrew use | sed -e 's/^Currently using //' -e 's/^perl-//')
	else
		if which plenv &> /dev/null; then
			perlversion=$(plenv version | sed -e 's/ (set.*$//')
		fi
	fi
	echo $perlversion$(_get_perllocallib)
}
_get_perllocallib () {
	local perllocallib
	if [[ -n "$PERL_LOCAL_LIB_ROOT" ]] ; then
		perllocallib=$(perl -MFile::Spec::Functions=abs2rel -le '($a = shift) =~s/\A:+//msx;print abs2rel($a)' $PERL_LOCAL_LIB_ROOT)
		echo "%{$reset_color%}|llib:${KOMACHI_PERL_LOCALLIB_COLOR}$perllocallib"
	fi
}

if [[ "$(_get_perlversion)" != "" ]] ; then
  KOMACHI_PLENV_="$KOMACHI_BRACKET_COLOR"[pl:"$KOMACHI_PLENV_COLOR\${\$(_get_perlversion)}$KOMACHI_BRACKET_COLOR"]"%{$reset_color%}"
fi
if [[ "$(_get_rubyversion)" != "" ]] ; then
	KOMACHI_RVM_="$KOMACHI_BRACKET_COLOR"[rb:"$KOMACHI_RVM_COLOR\${\$(_get_rubyversion)}$KOMACHI_BRACKET_COLOR"]"%{$reset_color%}"
fi


KOMACHI_DIR_="$KOMACHI_DIR_COLOR%~\$(git_prompt_info)%{$reset_color%} "
KOMACHI_PROMPT="%(?,%{$fg[green]%}(^_^%)%{$reset_color%},%{$fg[red]%}(T^T%)%{$reset_color%}) $"
KOMACHI_HOST_='%n@%m:'

# Put it all together!
PROMPT="$KOMACHI_HOST_$KOMACHI_DIR_
$KOMACHI_PROMPT%{$reset_color%} "
RPROMPT="$KOMACHI_PLENV_$KOMACHI_RVM_"

# vim:ft=zsh si ts=2 sw=2 sts=2:
