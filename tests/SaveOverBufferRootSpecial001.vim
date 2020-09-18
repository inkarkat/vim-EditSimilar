" Test SaveOverBufferAs command with special characters in SavePlus.

source helpers/NumAndFile.vim
set hidden
call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit \#foo\ bar.tmp
call IsNameAndNoFile('#foo bar.tmp', 'temp buffer does not exist on disk')
call setline(1, 'temp insert')
edit \#foo\ bar.txt
call vimtap#err#ErrorsLike('^E139:', 'SaveRoot tmp', 'File is loaded in another buffer')

try
    SaveRoot! tmp
    call IsNameAndFile('#foo bar.tmp', 'SaveRoot! tmp')
finally
    call delete('#foo bar.tmp')
endtry

call vimtest#Quit()
