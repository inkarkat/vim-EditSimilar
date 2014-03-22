" Test EditNext and EditPrevious with mismatching glob.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

edit foobar
echomsg 'Test: EditNext file* on foobar file'
EditNext file*
call IsNameAndFile('foobar', 'EditNext file* on foobar file')

echomsg 'Test: EditNext foobar on foobar file'
EditNext foobar
call IsNameAndFile('foobar', 'EditNext foobar on foobar file')

echomsg 'Test: EditNext doesnotexist on foobar file'
EditNext doesnotexist
call IsNameAndFile('foobar', 'EditNext doesnotexist on foobar file')

call vimtest#Quit()
