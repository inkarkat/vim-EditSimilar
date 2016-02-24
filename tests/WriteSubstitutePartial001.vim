" Test WriteSubstitute of partial buffer contents.

execute 'cd' expand('<sfile>:p:h') . '/testdata'

edit foobar.txt
try
    3,$WriteSubstitute o=C bar=baz txt=out
    edit fCCbaz.out
    call vimtest#SaveOut()
finally
    call delete('fCCbaz.out')
endtry

call vimtest#Quit()
