" Test EditNext and EditPrevious.
" Tests various counts before and after the command.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(22)
cd testdata

edit file004.txt
EditNext
call IsNameAndFile('file005.txt', 'EditNext')
1EditNext
call IsNameAndFile('file006.txt', '1EditNext')
1EditNext
call IsNameAndFile('file007.txt', '1EditNext')
EditNext
call IsNameAndFile('file009.txt', 'EditNext')
4EditNext
call IsNameAndFile('file100.txt', '4EditNext')
999EditNext
call IsNameAndFile('lala.txt', '999EditNext to last file')

call vimtap#err#Errors('No next file', 'EditNext', 'error')
call IsNameAndFile('lala.txt', 'EditNext on last file')

EditPrevious
call IsNameAndFile('lala.install', 'EditPrevious')
999EditPrevious
call IsNameAndFile('fXXbaz.txt', '999EditPrevious to first file')

call vimtap#err#Errors('No previous file', 'EditPrevious', 'error')
call IsNameAndFile('fXXbaz.txt', 'EditPrevious on first file')

call vimtest#Quit()
