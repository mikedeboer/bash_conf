" ensure Filetype Plugin and Indent plugins are enabled
filetype plugin indent on

" default undetected file types to text
autocmd BufNewFile,BufRead * setfiletype text

" viminfo : Save 20 search items, commands, files; disable hlsearch on load
set viminfo=/20,:20,'20,h

" general indent options (overridden by FileType)
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set cindent

" usability options
" See http://vimdoc.sourceforge.net/htmldoc/options.html
set nocompatible                " leave the 1970s
set nobackup                    " no backup files
set ruler                       " show ruler
set laststatus=2                " always show status
set hlsearch                    " hilight search results
set incsearch                   " find-as-you-type
set showmode                    " show Insert/Replace/Visual state
set backspace=indent,eol,start      " allow BS over autoindent, start-of-insert
set virtualedit=block           " restrain the cursor
set nowrap                      " don't wrap long lines
set visualbell                  " flash screen instead of beeping
set noerrorbells                " kill bell anyways
set vb t_vb=                    " really REALLY no screenflashes!
set cursorline			" highlight current line
set formatoptions-=t            " don't auto-indent plaintext
set wildmode=list:longest,full  " proper command-line tab completion
set wildmenu                    " show command-line wildcard matches in a menu

" statusline: buf: filename mode [type] ... position [ASCII:HEX] % of file
set statusline=%<%02n:\ %f\ %m%r\ %y%=%l,%c%V\ of\ %L\ [%03.3b:0x%02.2B]\ %P
" enable spell checking for text and html files
autocmd FileType html,text set spell
autocmd FileType html,text set ignorecase

" sane text-editing options
autocmd FileType text set textwidth=80
autocmd FileType text set formatoptions-=c
autocmd FileType text set formatoptions+=n,2
autocmd FileType text set smartcase
autocmd FileType text set noautoindent nosmartindent nocindent

" arrow keys
map <Up> gk
imap <Up> <C-o>gk
map <Down> gj
imap <Down> <C-o>g


" enable syntax highlighting of console colors are supports
if &t_Co > 1
    syntax on
endif

" default .sh syntax to bash
let g:is_bash = 1
