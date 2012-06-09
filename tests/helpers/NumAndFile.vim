function! IsName( name, description )
    call vimtap#Is(expand('%:t'), a:name, a:description)
endfunction
function! IsNum( number, description )
    call vimtap#Is(expand('%:t'), printf('file%03d.txt', a:number), a:description . ' (number)')
endfunction

function! IsNameAndFile( name, description )
    call IsName(a:name, a:description)
    call vimtap#file#IsFile(a:description)
endfunction

function! IsNumAndFile( number, description )
    call IsNum(a:number, a:description)
    call vimtap#file#IsFile(a:description)
endfunction
function! IsNumAndNoFile( number, description )
    call IsNum(a:number, a:description)
    call vimtap#file#IsNoFile(a:description)
endfunction
