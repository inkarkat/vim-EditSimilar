" Test EditPlus and EditMinus error conditions.

cd testdata

" Tests error about no number in filespec.
edit foobar.txt
echomsg 'Test: EditPlus on filespec without number'
EditPlus
echomsg 'Test: EditMinus on filespec without number'
100EditMinus!

" Tests error when trying to edit a next file when the current buffer has
" unsaved changes.
edit file004.txt
normal! ggiEdited.
echomsg 'Test: EditPlus on unsaved changes'
EditPlus

call vimtest#Quit()
