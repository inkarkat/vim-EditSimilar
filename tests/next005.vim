" Test EditNext and EditPrevious with non-existing file.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

edit newfile.txt
call vimtap#err#ErrorsLike('Cannot locate current file: .*[/\\]testdata[/\\]newfile.txt', 'EditNext', 'error')
call IsNameAndNoFile('newfile.txt', 'EditNext')

call vimtap#err#ErrorsLike('Cannot locate current file: .*[/\\]testdata[/\\]newfile.txt', 'EditPrevious', 'error')
call IsNameAndNoFile('newfile.txt', 'EditPrevious')

call vimtest#Quit()
