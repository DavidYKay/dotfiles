" adjust configuration for such hostile environment as Windows {{{
  " lang C
  " set viminfo='20,\"512,nc:/tmp/_viminfo
  " set iskeyword=48-57,65-90,97-122,_,161,163,166,172,177,179,182,188,191,198,202,209,211,230,234,241,243,143,156,159,165,175,185

if has('win32')
    set guifont=Consolas:h11
elseif has('unix')
    set guifont=ProggyCleanTT\ 12
elseif has('mac')
    set gfn=Monaco:h10
endif

colo gentooish
