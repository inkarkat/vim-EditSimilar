" Test EditNext and EditPrevious with the sole file in the directory.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit 001/prod/prod001.txt
echomsg 'Test: EditNext'
EditNext
call IsNameAndFile('prod001.txt', 'EditNext')

echomsg 'Test: EditPrevious'
EditPrevious
call IsNameAndFile('prod001.txt', 'EditPrevious')

call vimtest#Quit()
