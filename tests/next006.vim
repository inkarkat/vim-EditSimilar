" Test EditNext and EditPrevious skipping of wildignore matches.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

set wildignore=*.description,lala.txt
edit lala.desc
EditNext
call IsNameAndFile('lala.install', 'EditNext')
echomsg 'Test: No next file'
EditNext
call IsNameAndFile('lala.install', 'EditNext')

call vimtest#Quit()
