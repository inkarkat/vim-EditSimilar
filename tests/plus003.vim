" Test EditPlus and EditMinus error conditions.

cd testdata

call vimtest#StartTap()
call vimtap#Plan(3)

" Tests error about no number in filespec.
edit foobar.txt
try
    EditPlus
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No number in filespec', 'EditPlus on filespec without number')
endtry

try
    100EditMinus!
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No number in filespec', 'EditMinus on filespec without number')
endtry

" Tests error when trying to edit a next file when the current buffer has
" unsaved changes.
edit file004.txt
normal! ggiEdited.
try
    EditPlus
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No write since last change', 'EditPlus on unsaved changes')
endtry

call vimtest#Quit()
