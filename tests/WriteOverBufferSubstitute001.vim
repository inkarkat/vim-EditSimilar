" Test WriteOverBuffer of partial buffer contents use in WriteSubstitute.

source helpers/NumAndFile.vim
set hidden
call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit fXXbaz.out
call setline(1, 'temp insert')
edit foobar.txt
call vimtap#err#ErrorsLike('^E139:', '3,$WriteSubstitute o=X bar=baz txt=out', 'File is loaded in another buffer')

try
    3,$WriteSubstitute! o=X bar=baz txt=out
    edit fXXbaz.out
    call vimtest#SaveOut()
finally
    call delete('fXXbaz.out')
endtry

call vimtest#Quit()
