" Test EditNext and EditPrevious error conditions. 

" Tests error about no number in filespec. 
edit foobar.txt
echomsg 'Test: EditNext on filespec without number'
EditNext
echomsg 'Test: EditPrevious on filespec without number'
100EditPrevious!

" Tests error when trying to edit a next file when the current buffer has
" unsaved changes. 
edit file004.txt
normal! ggiEdited.
echomsg 'Test: EditNext on unsaved changes'
EditNext

call vimtest#Quit()
