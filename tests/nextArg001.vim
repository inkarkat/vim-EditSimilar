" Test EditNext and EditPrevious with passed glob.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(18)
cd testdata

edit foobar
EditNext foo*
call IsNameAndFile('foobar.cpp', 'EditNext foo*')
EditNext foo*
call IsNameAndFile('foobar.orig.txt', 'EditNext foo*')
EditNext foo*
call IsNameAndFile('foobar.txt', 'EditNext foo*')

try
    EditNext foo*
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No next file matching foo*', 'error')
endtry
call IsNameAndFile('foobar.txt', 'EditNext foo* on last file')
EditNext
call IsNameAndFile('lala.desc', 'EditNext on last foo* file')


edit foobar.cpp
EditPrevious foo*
call IsNameAndFile('foobar', 'EditPrevious foo*')

try
    EditPrevious foo*
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No previous file matching foo*', 'error')
endtry
call IsNameAndFile('foobar', 'EditPrevious foo* on first file')
EditPrevious
call IsNameAndFile('file[abc].txt', 'EditPrevious on first foo* file')

call vimtest#Quit()
