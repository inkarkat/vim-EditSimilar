" Test EditPlus and EditMinus error conditions.

cd testdata

call vimtest#StartTap()
call vimtap#Plan(3)

" Tests error about no number in filespec.
edit foobar.txt
call vimtap#err#Errors('No number in filespec', 'EditPlus', 'EditPlus on filespec without number')

call vimtap#err#Errors('No number in filespec', '100EditMinus!', 'EditMinus on filespec without number')

" Tests error when trying to edit a next file when the current buffer has
" unsaved changes.
edit file004.txt
normal! ggiEdited.
call vimtap#err#Errors('No write since last change', 'EditPlus', 'EditPlus on unsaved changes')

call vimtest#Quit()
