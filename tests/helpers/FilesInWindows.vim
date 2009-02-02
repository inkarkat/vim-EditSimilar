function! IsWindows( expectedFileList, description )
    let l:actualFileList = map(tabpagebuflist(), 'bufname(v:val)')
    call vimtap#Is(len(l:actualFileList), len(a:expectedFileList), a:description . ' (# of windows)')

    if len(l:actualFileList) > len(a:expectedFileList)
	call vimtap#Diag("additional windows:\n" . join(l:actualFileList[ len(a:expectedFileList) : ], "\n"))
    endif

    for l:i in range(0, len(a:expectedFileList) - 1)
	call vimtap#file#IsFilespec( get(l:actualFileList, l:i, ''), a:expectedFileList[l:i], a:description . ' (window #' . (l:i + 1) . ')' ) 
    endfor
endfunction

