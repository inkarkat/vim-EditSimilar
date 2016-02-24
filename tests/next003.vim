" Test EditNext and EditPrevious with the sole file in the directory.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit 001/prod/prod001.txt
echomsg 'Test: EditNext'
EditNext
call IsNameAndFile('prod001.txt', 'EditNext')

call vimtap#err#Errors('This is the sole file in the directory', 'EditPrevious', 'error')
call IsNameAndFile('prod001.txt', 'EditPrevious')

call vimtest#Quit()
