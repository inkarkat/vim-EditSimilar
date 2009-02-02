function! IsWindows( expectedFileList, description )
    let l:actualFileList = map(tabpagebuflist(), 'bufname(v:val)')
    let l:actualFileNum = len(l:actualFileList)
    let l:expectedFileNum = len(a:expectedFileList)

    let l:isFailure = 0
    let l:diag = ''
    for l:i in range(0, l:expectedFileNum - 1)
	let [l:isMatch, l:matchDiag] = vimtap#file#FilespecMatch(get(l:actualFileList, l:i, ''), a:expectedFileList[l:i])
	if ! l:isMatch
	    let l:isFailure = 1
	    let l:diag .= "\nwindow #" . (l:i + 1) . ": " . substitute(l:matchDiag, "\n", ' ', 'g')
	endif
    endfor

    if l:actualFileNum != l:expectedFileNum
	let l:isFailure = 1
	let l:diag .= "\nexpected " . l:expectedFileNum . ", " . 'but got ' . (l:actualFileNum < l:expectedFileNum ? 'only ' : '') . l:actualFileNum . ' windows' . (l:actualFileNum < l:expectedFileNum ? '' : '; additional windows:')
    endif
    if l:actualFileNum > l:expectedFileNum
	for l:i in range(l:expectedFileNum, l:actualFileNum)
	    let l:diag .= "\nwindow #" . (l:i + 1) . ": '" . l:actualFileList[l:i] . "'"
	endfor
    endif

    call vimtap#Ok(! l:isFailure, a:description)
    if l:isFailure
	call vimtap#Diag("Test '" . strtrans(a:description) . "' failed:" . l:diag)
    endif
endfunction

