syntax on

set t_Co=256
"
colo gentooish
"colo summerfruit256

"colo morning


"********************************
"BASICS
"********************************
"spaces rather than tabs
set expandtab
"set tabs to four spaces
set softtabstop=4
set tabstop=4
set shiftwidth=4
"set tabstop=4
"set noexpandtab
set autoindent smartindent
"set foldmethod=indent
set foldmethod=syntax

set backspace=eol,start,indent
"Reveal partially-typed commands
set showcmd
"Line numbers
set number

"store swap files centrally
set directory=~/.vim/tmp

set wildignore+=*/tmp/*,*/venv/*,*/packages/*,*/node_modules/*,*/bower_packages/*
set wildignore+=*/bin/*,*/obj/*,*/target/*
set wildignore+=*.so,*.class,*.dex,*.apk,*.dll,*.pyc,*.xib
set wildignore+=*.zip,*.mdb,*.sqlite
set wildignore+=*.png,*.jpg,*.pdf,*.xls,*.xlsx
set wildignore+=*.swp,#*

let g:ctrlp_root_markers =  ['.fiplr-root']
let g:ctrlp_custom_ignore = 'archive/'
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
"JAVA
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
"MACROS
"********************************
"
"map <F5> :!./run<CR>
map <F5> :Errors<cr>

" map ":make" to the F9 key
imap <F6> <ESC>:mak<CR>
nmap <F6> :mak<CR>

" Tag search
noremap <c-p> :CtrlPBufTagAll<CR>
"noremap <s-c-w> :CtrlPBufTagAll<CR>
"let g:ctrlp_map = '<s-c-e>'
let g:ctrlp_map = '<c-\>'
"let g:ctrlp_map = '<c-p>'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.dex,*.apk,*/build/*     " MacOSX/Linux

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

"Use ANT for compilation, rather than make
"NOT currently working
"autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
"autocmd BufRead set makeprg=ant\ -find\ build.xml
"
"REBIND Qwerty to DVORAK
"set langmap='q,\,w,.e,pr,yt,fy,gu,ci,ro,lp,/[,=],aa,os,ed,uf,ig,dh,hj,tk,nl,s\\;,-',\\;z,qx,jc,kv,xb,bn,mm,w\,,v.,z/,[-,]=,\"Q,<W,>E,PR,YT,FY,GU,CI,RO,LP,?{,+},AA,OS,ED,UF,IG,DH,HJ,TK,NL,S:,_\",:Z,QX,JC,KV,XB,BN,MM,W<,V>,Z?
"
"Do it using MACROS:
" Key to go into dvorak mode:
"
"map ,d :source ~/.dvorak Key to get out of dvorak mode: map ,q :source ~/.qwerty

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
let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1

" this should only be necessary if you don't have the ng client in your PATH
" let vimclojure#NailgunClient = "$HOME/bin/ng"
let vimclojure#WantNailgun = 1
let vimclojure#FuzzyIndent = 1

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
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*



"********************************
" Compilers
"********************************
" Use scons instead of GNU Make
set makeprg=scons

"********************************
"autocmd
"********************************
" Strip all whitespace before saving
autocmd FileType clojure,c,cpp,go,objc,java,javascript,php,python,thrift,html,xml autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd BufNewFile,BufRead *.cpp set formatprg=astyle\ -s2pb\ --style=java

"********************************
" Syntastic
"********************************

"let g:syntastic_c_include_dirs
let g:syntastic_cpp_include_dirs = [ 'includes', 'headers', 'src', 'lib', '/usr/include/jsoncpp']
let g:syntastic_python_checkers=['pylint']
let g:syntastic_java_javac_config_file_enabled=1
