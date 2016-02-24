" Test EditNext and EditPrevious honoring suffixes setting.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

set suffixes=.description
edit lala.desc
EditNext
call IsNameAndFile('lala.install', 'EditNext')
EditNext
call IsNameAndFile('lala.txt', 'EditNext')
EditNext
call IsNameAndFile('lala.description', 'EditNext to file matching suffixes')

call vimtest#Quit()
