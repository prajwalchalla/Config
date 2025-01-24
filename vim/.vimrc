"Auto Download
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'jiangmiao/auto-pairs' "auto completes [] and () and makes life a bit easier
Plug 'tpope/vim-commentary' "Comment stuff
Plug 'tpope/vim-fugitive' "The Git plugin for VIM
Plug 'tpope/vim-surround' "Allows me to change { to [ and what not
Plug 'wellle/targets.vim' "adds more targets like [ or , - lazy but useful
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'rhysd/vim-clang-format'
Plug 'itchyny/calendar.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

source ~/.coc.nvimrc

filetype plugin indent on
syntax on "activates syntax highlighting among other things
set nu
set cursorline
set background=dark "set bg group to dark
set backspace=indent,eol,start "Fixes the backspace
set conceallevel=1 "Allows me to conceal latex syntax if not on line
set encoding=utf-8 "required by YCM
set tabstop=4
set shiftwidth=4
set expandtab
set foldlevel=99
set foldmethod=indent "fold your code.
set hidden "work with multiple unsaved buffers.
set incsearch "highlights as you search
set ignorecase
set smartcase
set splitbelow splitright
set termguicolors "True colors term support
set viminfo+=n~/.vim/viminfo
set omnifunc=syntaxcomplete#Complete
set undodir="~/.vim/undo/"
set undofile
set laststatus=2
set showcmd
set guifont=MesloLGMDZ\ Nerd\ Font\ Bold\ 16

"set term=xterm-256color

"Theme

" use 256 colors in terminal
if !has("gui_running")
        set t_Co=256
        set term=xterm-256color
endif

let g:gruvbox_italic='1'
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
let g:gruvbox_termcolors='256'
let g:AutoPairsFlyMode=0
colorscheme gruvbox "colorscheme

highlight ExtraWhitespace ctermbg=red guibg=red
:fu FuncSpaceCheck()
        match ExtraWhitespace /\s\+$/
        au BufWinEnter * match ExtraWhitespace /\s\+$/
        au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        au InsertLeave * match ExtraWhitespace /\s\+$/
        au BufWinLeave * call clearmatches()
:endfu

:highlight Style ctermbg=red guibg=red
:fu FuncCPPCheck()
	call matchadd('Style', '\%>80v.\+', -1) " line over 80 char
	call matchadd('Style', '^\s* \s*', -1)  " spaces instead of tabs
	call matchadd('Style', '[\t ]\(for\|if\|select\|switch\|while\|catch\)(', -1)
		"missing space after control statement
	call matchadd('Style', '^\(\(?!\/\/\|\/\*\).\)*//\S', -1)
		" Missing space at comment start

	call matchadd('Style', '^\(\(?!\/\/\|\/\*\).\)*\w[,=>+\-*;]\w', -1)
	call matchadd('Style', '^\(\(?!\/\/\|\/\*\).\)*\w\(<<\|>>\)\w', -1)
		"operator without space around it (without false positive on
		"templated<type>)
	call matchadd('Style', '^[^#]^\(\(?!\/\/\|\/\*\).\)*[^<]\zs\w*/\w', -1)
		"operator without space around it (without false positive on
		"#include <dir/file.h>)
	call matchadd('Style', '^[^/]\{2}.*\zs[^*][=/+\-< ]$', -1)
		"operator at end of line (without false positives on /* and */, nor
		"char*\nClass::method())
	call matchadd('Style', '^[^#].*\zs[^<]>$', -1)
		" > operator at EOL (without false positive on #include <file.h>)
	call matchadd('Style', '){', -1) " Missing space after method header
	call matchadd('Style', '}\n\s*else', -1) " Malformed else
	call matchadd('Style', '}\n\s*catch', -1) " Malformed catch
	call matchadd('Style', '\s$', -1) "Spaces at end of line
	call matchadd('Style', ',\S', -1) " Missing space after comma
	call matchadd('Style', '^}\n\{1,2}\S', -1)
		" Less than 2 lines between functions
	call matchadd('Style', '^}\n\{4,}\S', -1)
		" More than 2 lines between functions
:endfu

runtime ftplugin/man.vim

" autocmd FileType c,cpp setlocal equalprg=clang-format
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "ColumnLimit" : "0",
            \ "Standard" : "C++11",
            \ "IndentWidth" : "4",
            \ "BreakBeforeBraces" : "Stroustrup"}

" map to CTRL-K in C++ code
autocmd FileType c,cpp nnoremap <buffer><C-K> :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><C-K> :ClangFormat<CR>
" Toggle auto formatting:
" nmap <C-A> :ClangFormatAutoToggle<CR>

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" let g:calendar_google_calendar = 1
" let g:calendar_google_task = 1
" source ~/.cache/calendar.vim/credentials.vim

let g:coc_disable_startup_warning = 1
