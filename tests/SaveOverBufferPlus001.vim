" Test SaveOverBufferAs command use in SavePlus.

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
call vimtap#err#ErrorsLike('^E139:', 'SavePlus', 'File is loaded in another buffer')

try
    SavePlus!
    call IsNameAndFile('file008.txt', 'SavePlus!')
finally
    call delete('file008.txt')
endtry

call vimtest#Quit()
