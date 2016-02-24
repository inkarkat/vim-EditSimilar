" Test EditNext and EditPrevious skipping of wildignore matches.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

set wildignore=*.description,lala.txt
edit lala.desc
EditNext
call IsNameAndFile('lala.install', 'EditNext')
call vimtap#err#Errors('No next file', 'EditNext', 'error')
call IsNameAndFile('lala.install', 'EditNext')

call vimtest#Quit()
