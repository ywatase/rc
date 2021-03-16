call plug#begin('~/.vim/plugged')
Plug 'mattn/benchvimrc-vim', { 'on': 'BenchVimrc' }
Plug 'tpope/vim-fugitive'
Plug 'mtth/scratch.vim'

" filer
Plug 'cocopon/vaffle.vim'

" 最後のコミット以降の変更行が見れる。
Plug 'airblade/vim-gitgutter'

Plug 'itchyny/lightline.vim'
Plug 'thinca/vim-localrc'

Plug 'w0rp/ale', { 'for': ['perl'] }

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" folding
Plug 'LeafCage/foldCC'
Plug 'scrooloose/nerdcommenter'

" surround
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'thinca/vim-textobj-between'
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'

Plug 'vim-scripts/sudo.vim'
Plug 'glidenote/memolist.vim'

Plug 'bronson/vim-trailing-whitespace'

" reference viewer
Plug 'thinca/vim-ref'
Plug 'thinca/vim-quickrun'

" search
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-migemo.vim'

" snippet
Plug 'Shougo/neosnippet-snippets'
	\ | Plug 'Shougo/neosnippet'

Plug 'honza/vim-snippets'
Plug 'bonsaiben/bootstrap-snippets'

Plug 'mattn/emmet-vim'

" for Japanese Help
Plug 'vim-jp/vimdoc-ja'
" こんな感じで使う
" help {word}@ja
" helpgrep {word}@en
" 英語を優先したい場合
" :set helplang=en,ja

Plug 'cespare/vim-toml', { 'for': 'toml' }
" カーソル位置のコンテキストのファイルタイプを判定する
let g:vim_precious_enable = ['toml', 'jinja', 'markdown']
Plug 'osyo-manga/vim-precious', { 'for': g:vim_precious_enable }
Plug 'Shougo/context_filetype.vim', { 'for': g:vim_precious_enable }

" Language server protocol
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-neosnippet'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
let g:lsp_async_completion = 1

" Perl
Plug 'vim-perl/vim-perl', { 'for': 'perl' }
Plug 'ywatase/perldoc-vim', { 'for': 'perl' }
Plug 'ywatase/xslate-vim', { 'for': ['perl','xslate'] }
Plug 'moznion/vim-cpanfile', { 'for': 'cpanfile' }

"Plug 'moznion/syntastic-cpanfile'
"Plug 'ywatase/syntastic-cpanfile', { 'for': 'cpanfile', }

" Ruby
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }

" Javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" coffeescript
Plug 'kchmck/vim-coffee-script', { 'for': 'javascript' }

" Markdown
Plug 'hallison/vim-markdown', { 'for': 'markdown', 'do': 'cp snippets/markdown.snippets ~/.vim/snippets' }
Plug 'kannokanno/previm', { 'for': 'markdown' }
Plug 'tyru/open-browser.vim', { 'for': 'markdown' }
Plug 'thinca/vim-ft-markdown_fold', { 'for': 'markdown' }
Plug 'Konfekt/FastFold', { 'for': 'markdown' }
Plug 'ywatase/mdt.vim', { 'on': 'Mdt' }
Plug 'ywatase/md2fswiki.vim', { 'for': 'markdown' }

" ansible
Plug 'pearofducks/ansible-vim', { 'for': ['yaml', 'ansible'] }

" jinja2
Plug 'Glench/Vim-Jinja2-Syntax' , { 'for': ['jinjahtml', 'jinja'] }

" bats
Plug 'vim-scripts/bats.vim', { 'for': 'bats' }

" cloudformation
Plug 'lunarxlark/aws-cfn-snippet.vim', { 'for': 'cloudformation' }

Plug 'hashivim/vim-terraform', { 'for': 'tf' }

" colorscheme
Plug 'altercation/vim-colors-solarized'
Plug 'jacoborus/tender.vim'
Plug 'vim-scripts/jellybeans.vim'
Plug 'vim-scripts/mrkn256.vim'
call plug#end()
