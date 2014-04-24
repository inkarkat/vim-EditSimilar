" Test completion used by FileRoot.
" Tests that file extensions from all files in that directory are offered.

call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit foobar.txt
call vimtap#Is(EditSimilar#Root#CompleteAny('', '', 1), ['cpp', 'desc', 'description', 'install', 'orig.txt'], 'complete from foobar.txt')
edit fXXbaz.txt
call vimtap#Is(EditSimilar#Root#CompleteAny('', '', 1), ['cpp', 'desc', 'description', 'install', 'orig.txt'], 'complete from fXXbaz.txt')
call vimtap#Is(EditSimilar#Root#CompleteAny('d', '', 1), ['desc', 'description'], 'complete d from fXXbaz.txt')
call vimtap#Is(EditSimilar#Root#CompleteAny('x', '', 1), [], 'complete x from fXXbaz.txt')

call vimtest#Quit()
