" Test EditRoot completion corner cases.
" Tests that completion works from a file without file extension.
" Tests that there are no duplicates with multiple extensions (.txt, .orig.txt).

call vimtest#StartTap()
call vimtap#Plan(3)
cd testdata

edit foobar
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), ['cpp', 'txt'], 'complete from foobar')
call vimtap#Is(EditSimilar#Root#Complete('t', '', 1), ['txt'], 'complete t from foobar')
edit foobar.cpp
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), ['txt'], 'complete from foobar.cpp')

call vimtest#Quit()
