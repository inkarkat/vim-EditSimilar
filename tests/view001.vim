" Test read-only Vnext and Vprev. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(18)

edit file004.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
Vnext
call IsNumAndFile(5, 'Vnext')
call vimtap#Ok(&l:readonly, 'Vnext is readonly')
Vnext 2
call IsNumAndFile(7, '2Vnext')
call vimtap#Ok(&l:readonly, '2Vnext is readonly')


edit file007.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
echomsg 'Test: file008.txt does not exist'
Vnext
call IsNumAndFile(7, 'Vnext to missing file')
call vimtap#Ok(! &l:readonly, 'Original after Vnext still is not readonly')
Vnext!
call IsNumAndNoFile(8, 'Vnext! to missing file')
call vimtap#Ok(&l:readonly, 'Vnext! is readonly')

edit file020.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
999Vprev
call IsNumAndFile(3, '999Vprev to first file')
call vimtap#Ok(&l:readonly, '999Vprev is readonly')

call vimtest#Quit()

