"au BufNewFile,BufRead *.m,*.h set ft=objc

autocmd BufRead *.java set include=^#\s*import
autocmd BufRead *.java set includeexpr=substitute(v:fname,'\\.','/','g')
autocmd BufRead *.java set suffixesadd=.java

autocmd BufRead *.aidl set filetype=java

autocmd BufRead *.applescript set filetype=applescript
au BufRead,BufNewFile *.metal set filetype=cpp

au! BufRead,BufNewFile *.json set filetype=json
au! BufRead,BufNewFile *.jsbundle set filetype=javascript

autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala

au BufRead,BufNewFile SConstruct,SConscript,*.scons setfiletype python

au BufRead,BufNewFile *.thrift set filetype=thrift
au! Syntax thrift source ~/.vim/syntax/thrift.vim

" BGFX Shader Language
au BufRead,BufNewFile *.sc set filetype=glsl

au BufRead,BufNewFile *.dtm set filetype=clojure
au BufRead,BufNewFile *.cljs set filetype=clojure
au BufRead,BufNewFile *.cljc set filetype=clojure
au BufRead,BufNewFile *.edn set filetype=clojure
au BufRead,BufNewFile .lein-env set filetype=clojure
au BufRead,BufNewFile *.pxi set filetype=clojure

au BufRead,BufNewFile Podfile set filetype=ruby
au BufRead,BufNewFile Guardfile set filetype=ruby
au BufRead,BufNewFile *.m set filetype=objc

au BufRead,BufNewFile BUCK set filetype=python

au BufRead,BufNewFile *.gradle set filetype=groovy
au BufRead,BufNewFile *.gant set filetype=groovy

au BufRead,BufNewFile .spacemacs set filetype=lisp
au BufRead,BufNewFile *.pxi set filetype=clojure
au BufRead,BufNewFile meson.build set filetype=python

au BufRead,BufNewFile *.any set filetype=glsl
au BufRead,BufNewFile *.bazel set filetype=python
au BufRead,BufNewFile *.fs set filetype=fsharp
au BufRead,BufNewFile *.xaml.fs set filetype=fsharp
