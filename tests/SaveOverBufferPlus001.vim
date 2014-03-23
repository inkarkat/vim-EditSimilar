" Test SaveOverBuffer command.

source helpers/NumAndFile.vim
set hidden
call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit lala.txt
edit file008.txt
call IsNameAndNoFile('file008.txt', 'temp buffer does not exist on disk')
call setline(1, 'temp insert')
edit file007.txt
try
    SavePlus
    call vimtap#Fail('expected exception')
catch
    call vimtap#err#ThrownLike('^E139:', 'File is loaded in another buffer')
endtry

SavePlus!
call IsNameAndFile('file008.txt', 'SavePlus!')

call vimtest#Quit()
