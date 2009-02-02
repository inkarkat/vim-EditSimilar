function! IsNum( number, description )
    call vimtap#Is(expand('%:t'), printf('file%03d.txt', a:number), a:description . ' (number)')
endfunction
function! IsFile( description )
    call vimtap#Ok(filereadable(expand('%:p')), a:description . ' (file exists)')
endfunction
function! IsNoFile( description )
    call vimtap#Ok(! filereadable(expand('%')), a:description . ' (no file)')
endfunction

function! IsNumAndFile( number, description )
    call IsNum(a:number, a:description)
    call IsFile(a:description)
endfunction
function! IsNumAndNoFile( number, description )
    call IsNum(a:number, a:description)
    call IsNoFile(a:description)
endfunction
