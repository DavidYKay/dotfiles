" adjust configuration for such hostile environment as Windows {{{
if has("win32") || has("win16")
  " lang C
  " set viminfo='20,\"512,nc:/tmp/_viminfo
  " set iskeyword=48-57,65-90,97-122,_,161,163,166,172,177,179,182,188,191,198,202,209,211,230,234,241,243,143,156,159,165,175,185
else
  let os = substitute(system('uname'), "\n", "", "")
  if os == "Darwin"
    " set nomacatsui anti enc=utf-8 termencoding=macroman gfn=Monaco:h13
    " set macatsui enc=utf-8 gfn=Monaco:h13
    set gfn=Monaco:h10
  elseif os == "Linux"
    set guifont=ProggyCleanTT\ 12
  endif
endif
" }}}

colo gentooish
