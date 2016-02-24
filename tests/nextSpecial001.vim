" Test EditNext and EditPrevious ignoring dotfiles.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(18)
cd testdata

edit 001/special/\#lala.txt
EditNext
call IsNameAndFile('+foo bar.txt', 'EditNext')
EditNext
call IsNameAndFile('=foo bar.txt', 'EditNext')
EditNext
call IsNameAndFile('another.cpp', 'EditNext')
EditNext
call IsNameAndFile('foo bar.txt', 'EditNext')
EditNext
call IsNameAndFile('lala.txt', 'EditNext')

call vimtap#err#Errors('No next file', 'EditNext', 'error')
call IsNameAndFile('lala.txt', 'EditNext on last file')


edit 001/special/\#lala.txt
EditPrevious
call IsNameAndFile('#foo bar.txt', 'EditPrevious')

call vimtap#err#Errors('No previous file', 'EditPrevious', 'error')
call IsNameAndFile('#foo bar.txt', 'EditPrevious on first file')

call vimtest#Quit()
