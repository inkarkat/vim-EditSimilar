" Test read-only ViewNext and ViewPrevious. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(18)

edit file004.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
ViewNext
call IsNumAndFile(5, 'ViewNext')
call vimtap#Ok(&l:readonly, 'ViewNext is readonly')
ViewNext 2
call IsNumAndFile(7, '2VSplitNext')
call vimtap#Ok(&l:readonly, '2VSplitNext is readonly')


edit file007.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
echomsg 'Test: file008.txt does not exist'
1VSplitNext
call IsNumAndFile(7, '1VSplitNext to missing file')
call vimtap#Ok(! &l:readonly, 'Original after ViewNext still is not readonly')
ViewNext!
call IsNumAndNoFile(8, 'ViewNext! to missing file')
call vimtap#Ok(&l:readonly, 'ViewNext! is readonly')

edit file020.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
999ViewPrevious
call IsNumAndFile(3, '999ViewPrevious to first file')
call vimtap#Ok(&l:readonly, '999ViewPrevious is readonly')

call vimtest#Quit()
