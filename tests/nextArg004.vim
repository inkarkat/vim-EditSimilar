" Test EditNext and EditPrevious custom iteration order.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(8)
cd testdata

edit foobar
EditNext foobar file9999.txt file101.txt lala.txt foobar.cpp
call IsNameAndFile('file9999.txt', 'EditNext custom order on foobar file')

EditNext foobar file9999.txt file101.txt lala.txt foobar.cpp
call IsNameAndFile('file101.txt', 'EditNext custom order on file9999.txt file')

EditNext foobar file9999.txt file101.txt lala.txt foobar.cpp
call IsNameAndFile('lala.txt', 'EditNext custom order on file101.txt file')

EditNext foobar file9999.txt file101.txt lala.txt foobar.cpp
call IsNameAndFile('foobar.cpp', 'EditNext custom order on lala.txt file')

call vimtest#Quit()
