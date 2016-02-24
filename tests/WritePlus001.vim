" Test WritePlus of partial buffer contents.

execute 'cd' expand('<sfile>:p:h') . '/testdata'

file partials000.out
for s:cnt in range(2, 10) | call append('$', 'line ' . s:cnt) | endfor
setlocal nomodified
try
    1,3WritePlus
    4,6WritePlus 999
    7,$WritePlus 999

    enew
    for s:cnt in range(1, 3)
	let s:filename = printf('partials00%d.out', s:cnt)
	$put ='--- ' . s:filename . ' ---'
	execute '$read' s:filename
    endfor
    call vimtest#SaveOut()
finally
    call delete('partials003.out')
    call delete('partials002.out')
    call delete('partials001.out')
endtry

call vimtest#Quit()
