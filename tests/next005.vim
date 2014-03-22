" Test EditNext and EditPrevious with non-existing file.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit newfile.txt
echomsg 'Test: EditNext'
EditNext
call IsNameAndNoFile('newfile.txt', 'EditNext')

echomsg 'Test: EditPrevious'
EditPrevious
call IsNameAndNoFile('newfile.txt', 'EditPrevious')

call vimtest#Quit()
