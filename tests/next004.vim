" Test EditNext and EditPrevious with no files in the directory.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

edit 001/empty/newfile.txt
echomsg 'Test: EditNext'
call vimtap#err#Errors('No files in this directory', 'EditNext', 'error')
call IsNameAndNoFile('newfile.txt', 'EditNext')

call vimtap#err#Errors('No files in this directory', 'EditPrevious', 'error')
call IsNameAndNoFile('newfile.txt', 'EditPrevious')

call vimtest#Quit()
