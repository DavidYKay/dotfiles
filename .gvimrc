" adjust configuration for such hostile environment as Windows {{{
  " lang C
  " set viminfo='20,\"512,nc:/tmp/_viminfo
  " set iskeyword=48-57,65-90,97-122,_,161,163,166,172,177,179,182,188,191,198,202,209,211,230,234,241,243,143,156,159,165,175,185

if has('win32')
    set guifont=Consolas:h14
    colo slack
elseif has('unix')
    let hostname = substitute(system('hostname'), '\n', '', '')
    if hostname == "donkeyKong"
        "set guifont=Ubuntu\ Mono\ 14
        "set guifont=ProggyCleanTT\ 12
        "set guifont=Droid\ Sans\ Mono\ 10
        "set guifont=Droid\ Sans\ Mono\ 11
        "set guifont=Droid\ Sans\ Mono\ 12
        "set guifont=Droid\ Sans\ Mono\ 13
        "set guifont=Droid\ Sans\ Mono\ 14
        set guifont=Source\ Code\ Pro\ 14
        "set guifont=Source\ Code\ Pro\ 15
        "set guifont=Source\ Code\ Pro\ 13
        "set guifont=Droid\ Sans\ Mono\ 16
        "set guifont=Droid\ Sans\ Mono\ 18
        "set guifont=Droid\ Sans\ Mono\ 20
        "colo slack
        colo gentooish
    else
        if hostname == "neoKong"
            "set guifont=Droid\ Sans\ Mono\ 11
            set guifont=Source\ Code\ Pro\ 10
            "set guifont=Source\ Code\ Pro\ 20
            "set guifont=Source\ Code\ Pro\ 24
            "set guifont=Source\ Code\ Pro\ 14
            "set guifont=Source\ Code\ Pro\ 16
        else
            set guifont=ProggyCleanTT\ 12
            "set guifont=ProggyCleanTT\ 14
            colo gentooish
        endif
    endif
elseif has('mac')
    set gfn=Monaco:h10
    colo gentooish
endif

