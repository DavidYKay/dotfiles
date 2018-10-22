syntax on
set t_Co=256

colo gentooish
"colo summerfruit256
"colo morning

"********************************
"BASICS
"********************************
"spaces rather than tabs
set expandtab
"set tabs to four spaces
set softtabstop=2
set tabstop=2
set shiftwidth=2

"set foldmethod=indent
set foldmethod=syntax

set backspace=eol,start,indent
"Reveal partially-typed commands
set showcmd
"Line numbers
set number

"store swap files centrally
set directory=~/.vim/tmp

set wildignore+=*/tmp/*,*/venv/*,*/node_modules/*,*/bower_packages/*,*/_site/*,*/data/*
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.dex,*.apk,*/build/*     " MacOSX/Linux
set wildignore+=*/xcuserdata/*
set wildignore+=*/bin/*,*/obj/*,*/target/*,*/out/*,*/ui-out/*
set wildignore+=*/dist/*,*/Pods/*
set wildignore+=*/deps/*
set wildignore+=*.swp,#*
set wildignore+=*.o,*.so,*.class,*.dex,*.apk,*.dll,*.pyc,*.xib
set wildignore+=*.zip,*.mdb,*.sqlite
set wildignore+=*.png,*.jpg,*.pdf,*.xls,*.xlsx

let g:ctrlp_root_markers =  ['.fiplr-root']
"let g:ctrlp_custom_ignore = 'lib/'
"let g:ctrlp_custom_ignore = 'archive/'
"let g:ctrlp_custom_ignore = {
  "\ 'dir':  '\v[\/]\.(git|hg|svn)$',
  "\ 'file': '\v\.(exe|so|dll)$',
  "\ 'link': 'some_bad_symbolic_links',
  "\ }

"********************************
"GUI
"********************************

" Remove menu bar
set guioptions-=m

" Remove toolbar
set guioptions-=T

"********************************
"PLUGINS
"********************************
"Required for Project.vim
set nocompatible

"PLUGIN enablers
set nocp 

"********************************
" Zig
"********************************

imap <C-x> :AsyncRun ./build.sh<CR>

"********************************
" Java
"********************************
"Set up Java + Ant for QuickFix
"autocmd BufRead *.java set makeprg=ant\ -f\ /home/demian/code/jim/build.xml   
autocmd BufRead *.java set makeprg=ant\ -f\ ./build.xml
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

"Make import statements work with gf 'goto file'
autocmd BufRead *.java set include=^#\s*import 
autocmd BufRead *.java set includeexpr=substitute(v:fname,'\\.','/','g')

"Map gc to go to class definition in file
map gc gdb<C-W>f
"Map gf to open file in new buffer
map gf <C-W>f

"********************************
" Search
"********************************

function! FindProjectRoot(buffer) abort
    for l:path in ale#path#Upwards(expand('#' . a:buffer . ':p:h'))
        if isdirectory(l:path . '/.git')
        \|| filereadable(l:path . '/.fiplr-root')
            return l:path
        endif
    endfor

    return ''
endfunction

function! SetBufferDirToProjectRoot() 
  let current_buff = bufnr("%")
  let root = FindProjectRoot(l:current_buff)
  execute "normal!" ":lcd" root "\<cr>"
endfunction

" Set current buffer's root directory to project root
map <C-h> :.call SetBufferDirToProjectRoot()<CR>
map <C-s> :source %<CR>

"----------
" Ctrl-p
"----------

" Tag search
noremap <c-p> :CtrlPBufTagAll<CR>
"noremap <s-c-w> :CtrlPBufTagAll<CR>
let g:ctrlp_map = '<c-\>'
"let g:ctrlp_map = '<c-p>'

"----------
" fzf
"----------
map <C-l> :Ag<CR>

"********************************
" Hotkeys - Core
"********************************

"map <F5> :!./run<CR>
"map <F5> :Errors<cr>
map <F5> :Buffers<cr>

imap <F6> <ESC>:mak<CR>
nmap <F6> :mak<CR>

"map <F10> :Errors<cr>
"map <F10> :CtrlPBufTagAll<cr>
"map <c-,> :CtrlPBufTagAll<cr>

" Strip whitespace
":nnoremap <silent> <F10> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Poor man's make for individual file
"imap <F10> <ESC>:!javac .java && java <CR>
"nmap <F10> :!javac .java && java <CR>

"SHOW trailing whitespace
"set listchars=tab:>-,trail:·,eol:$
"nmap <silent> <leader>s :set nolist!<CR>

"Shorted command prompt interruptions
"i.e. Press ENTER or type command to continue
set shortmess=atI

"Buffer management
map <C-Tab> <C-W><C-W>
map <S-Right> :bnext<CR>
map <S-Left> :bprevious<CR>
map <A-Right> :bnext<CR>
map <A-Left> :bprevious<CR>

"********************************
"MISC
"********************************
"Adjusts how early the screen scrolls(based on cursor position)
set scrolloff=3

"set terminal title to vim
set title
"enable multiple buffers
"set hidden
"enable wildcard matching in command mode
set wildmenu

"********************************
"OMNI COMPLETION
"********************************
filetype plugin on 
filetype indent on 

"********************************
"ABBREVIATIONS
"********************************
"abb ost OverallSalesTotal
abb excp Exception

"********************************
"CTAGS
"********************************
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
"let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_WinWidth = 50

" Alternate file
map <F1> :A<cr>
map <F2> :NERDTree<cr>
map <F3> :Project<cr>
map <F4> :TlistToggle<cr>
"map <F1> :NERDTreeClose<cr>

"set g:proj_flags=imstc

let g:tlist_javascript_settings = 'javascript;s:string;a:array;o:object;f:function'

"********************************
" Clojure
"********************************
" Treat / and . as a keyword. Makes Clojure editing nicer. Althouh
au FileType clojure set iskeyword=@,48-57,_,191-255
au FileType clojure set iskeyword-=.

" let g:vimclojure#HighlightBuiltins = 1
" let g:vimclojure#ParenRainbow = 1

" this should only be necessary if you don't have the ng client in your PATH
" let vimclojure#NailgunClient = "$HOME/bin/ng"
" let vimclojure#WantNailgun = 1
" let vimclojure#FuzzyIndent = 1

"let classpath = join(
   "\[".",
   "\ "src", "src/main/clojure", "src/main/resources",
   "\ "test", "src/test/clojure", "src/test/resources",
   "\ "classes", "target/classes",
   "\ "lib/*", "lib/dev/*",
   "\ "bin",
   "\ vimfiles."/lib/*"
   "\],
   "\ sep)

"********************************
"PATHOGEN
"********************************
call pathogen#infect()

"********************************
"GUI/HUD
"********************************
" Always show status line
set laststatus=2

" Jumbo status line
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]

set statusline+=%#warningmsg#
set statusline+=%*

"********************************
"autocmd
"********************************
" Strip all whitespace before saving
autocmd FileType clojure,c,cpp,go,objc,java,javascript,php,python,thrift,html,xml autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd BufNewFile,BufRead *.cpp set formatprg=astyle\ -s2pb\ --style=java

"********************************
" Location List (Ale / Syntastic)
"********************************

map <C-i> :ll<CR>
map <C-j> :lnext<CR>
map <C-k> :lprev<CR>

"********************************
" Vim-Plug
"********************************

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'https://github.com/romainl/vim-qf.git'

Plug 'SirVer/ultisnips'

Plug 'DavidYKay/ale'
"Plug 'w0rp/ale'

call plug#end()
