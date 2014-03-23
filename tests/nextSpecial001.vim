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

try
    EditNext
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No next file', 'error')
endtry
call IsNameAndFile('lala.txt', 'EditNext on last file')


edit 001/special/\#lala.txt
EditPrevious
call IsNameAndFile('#foo bar.txt', 'EditPrevious')

try
    EditPrevious
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No previous file', 'error')
endtry
call IsNameAndFile('#foo bar.txt', 'EditPrevious on first file')

call vimtest#Quit()
