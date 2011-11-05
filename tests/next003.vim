" Test Enext and Eprev error conditions. 

" Tests error about no number in filespec. 
edit foobar.txt
echomsg 'Test: Enext on filespec without number'
Enext
echomsg 'Test: Eprev on filespec without number'
100Eprev!

" Tests error when trying to edit a next file when the current buffer has
" unsaved changes. 
edit file004.txt
normal! ggiEdited.
echomsg 'Test: Enext on unsaved changes'
Enext

call vimtest#Quit()

