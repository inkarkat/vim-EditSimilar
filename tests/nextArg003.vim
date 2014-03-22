" Test EditNext and EditPrevious with multiple globs.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(18)
cd testdata

edit foobar.cpp
EditNext *.cpp *.desc*
call IsNameAndFile('lala.desc', 'EditNext *.cpp *.desc* on foobar.cpp file')

EditNext *.cpp *.desc*
call IsNameAndFile('lala.description', 'EditNext *.cpp *.desc* on lala.desc file')

echomsg 'Test: No next *.cpp *.desc* file'
EditNext *.cpp *.desc*
call IsNameAndFile('lala.description', 'EditNext *.cpp *.desc* on last matching file')


edit 001/special/foo\ bar.txt
EditPrevious *foo\ bar*
call IsNameAndFile('=foo bar.txt', 'EditPrevious *foo\ bar* on foo bar.txt')
EditPrevious *foo\ bar*
call IsNameAndFile('+foo bar.txt', 'EditPrevious *foo\ bar* on =foo bar.txt')
EditPrevious *foo\ bar*
call IsNameAndFile('#foo bar.txt', 'EditPrevious *foo\ bar* on +foo bar.txt')

" Tests that escaped whitespace is correctly parsed as one glob.
echomsg 'Test: No previous *foo\ bar* file'
EditPrevious *foo\ bar*
call IsNameAndFile('#foo bar.txt', 'EditPrevious *foo\ bar* on +foo bar.txt')

" Tests that glob splitting still works together with escaped whitespace.
EditPrevious .foo\ bar* *foo\ bar*
call IsNameAndFile('.foo bar.txt', 'EditPrevious .foo\ bar* *foo\ bar* on #foo bar.txt')

EditNext .foo\ bar* *.cpp
call IsNameAndFile('another.cpp', 'EditNext .foo\ bar* *.cpp on .foo bar.txt')

call vimtest#Quit()