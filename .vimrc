"********************************
" Vim-Plug
"********************************

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'ervandew/supertab'

Plug 'SirVer/ultisnips'

" Plug 'w0rp/ale'
" Plug 'https://github.com/romainl/vim-qf.git'
Plug 'DavidYKay/ale', { 'branch': 'feature/d-meson' }

Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}

" Plug 'kongo2002/fsharp-vim'
Plug 'beyondmarc/hlsl.vim'
Plug 'cespare/vim-toml'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'hdiniz/vim-gradle'
Plug 'keith/swift.vim'
Plug 'morhetz/gruvbox'
Plug 'petRUShka/vim-opencl'
Plug 'rodjek/vim-puppet'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-markdown'
Plug 'udalov/kotlin-vim'

call plug#end()

" Core Config
syntax on
set t_Co=256

colo palenight
"colo gruvbox
"colo gentooish
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

set wildignore+=*/tmp/*,*/venv/*,*/node_modules/*,*/bower_packages/*,*/_site/*
"*/data/*
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.dex,*.apk,*/build/*     " MacOSX/Linux
set wildignore+=*/xcuserdata/*,*/packages/*
set wildignore+=*/bin/*,*/obj/*,*/target/*,*/out/*,*/ui-out/*,*/builddir/*
set wildignore+=*/dist/*,*/Pods/*
set wildignore+=*/deps/*
set wildignore+=*.swp,#*
set wildignore+=*.o,*.so,*.class,*.dex,*.apk,*.dll,*.pyc,*.xib
set wildignore+=*.zip,*.mdb,*.sqlite
set wildignore+=*.png,*.jpg,*.pdf,*.xls,*.xlsx

let g:ctrlp_root_markers =  ['.fiplr-root']
let g:ctrlp_custom_ignore = '3rdparty/'
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
map <C-c> :lcd %:p:h <CR>
map <C-h> :.call SetBufferDirToProjectRoot()<CR>
map <C-s> :source %<CR>
"----------
" Ctrl-p
"----------

" Tag search
noremap <c-p> :CtrlPBufTagAll<CR>
let g:ctrlp_map = '<c-\>'

"----------
" fzf
"----------
map <C-l> :Ag<CR>

"********************************
" Hotkeys - Core
"********************************

function! NewFileInDir()
  call inputsave()
  let filename = input('Enter filename: ')
  call inputrestore()
  execute "normal! :vs %:h/" . filename . "\<cr>"
endfunction

" Custom nav
map <C-n> :.call NewFileInDir()<CR>
map <F5> :Buffers<cr>

"map <F10> :Errors<cr>

" Strip whitespace
:nnoremap <silent> <F10> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

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
" TODO: nix Pathogen for Vim-Plug
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
" Compile / Lint (ALE, et al.)
"********************************

"nmap <F6> :mak<CR>
nmap <C-b> :silent exec "!dkBuild"<CR>

" Ale / Syntastic
map <S-t> :ALEToggle<CR>

map <C-a> :lopen<CR>
map <C-x> :lclose<CR>
map <C-i> :ll<CR>
map <C-j> :lnext<CR>
map <C-k> :lprev<CR>
map <C-space> :r !xclip -o<CR>
imap <C-space> <ESC>:r !xclip -o<CR>

"\   'd': ['meson'],
let g:ale_linters = {
\   'd': ['dmd'],
\   'cpp': ['clang'],
\}

nmap <silent> <Tab> :ALEDetail<CR>
nmap <silent> <S-Tab> :pclose<CR>
nmap <silent> <C-F2> :source %<CR>

" Paste functionality
" Ctrl-PageUp as a holdover
" nmap <C-PageUp> "*p
" Having trouble getting Ctrl-Space to work:
" nmap <C-@> "*p
" nmap <c-space> "*p
