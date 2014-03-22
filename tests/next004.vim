" Test EditNext and EditPrevious with no files in the directory.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit 001/empty/newfile.txt
echomsg 'Test: EditNext'
EditNext
call IsNameAndNoFile('newfile.txt', 'EditNext')

echomsg 'Test: EditPrevious'
EditPrevious
call IsNameAndNoFile('newfile.txt', 'EditPrevious')

call vimtest#Quit()
