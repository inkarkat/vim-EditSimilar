function! IsBuffers( buffers, description )
    let l:listedBuffers = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'fnamemodify(bufname(v:val), ":t")')
    call vimtap#collections#IsSet(l:listedBuffers, a:buffers, a:description, 1)
endfunction
