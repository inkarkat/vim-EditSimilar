" Test WriteSubstitute of partial buffer contents.

execute 'cd' expand('<sfile>:p:h') . '/testdata'

edit foobar.txt
try
    3,$WriteSubstitute o=X bar=baz txt=out
    edit fXXbaz.out
    call vimtest#SaveOut()
finally
    call delete('fXXbaz.out')
endtry

call vimtest#Quit()
