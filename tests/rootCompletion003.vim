" Test EditRoot completion corner cases.
" Tests that completion works from a file without file extension.
" Tests that there are no duplicates with multiple extensions (.txt, .orig.txt).

call vimtest#StartTap()
call vimtap#Plan(11)
cd testdata

edit foobar
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), ['cpp', 'orig.txt', 'txt'], 'complete from foobar')
call vimtap#Is(EditSimilar#Root#Complete('.', '', 1), ['.cpp', '.orig.txt', '.txt'], 'complete . from foobar')
call vimtap#Is(EditSimilar#Root#Complete('o', '', 1), ['orig.txt'], 'complete o from foobar')
call vimtap#Is(EditSimilar#Root#Complete('orig.t', '', 1), ['orig.txt'], 'complete orig.t from foobar')
call vimtap#Is(EditSimilar#Root#Complete('t', '', 1), ['txt'], 'complete t from foobar')
call vimtap#Is(EditSimilar#Root#Complete('.t', '', 1), ['.txt'], 'complete .t from foobar')
edit foobar.cpp
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), ['orig.txt', 'txt'], 'complete from foobar.cpp')
call vimtap#Is(EditSimilar#Root#Complete('t', '', 1), ['txt'], 'complete t from foobar.cpp')
edit foobar.orig.txt
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), [], 'complete from foobar.orig.txt')
call vimtap#Is(EditSimilar#Root#Complete('.', '', 1), [], 'complete . from foobar.orig.txt')
call vimtap#Is(EditSimilar#Root#Complete('..', '', 1), ['..cpp'], 'complete .. from foobar.orig.txt')

call vimtest#Quit()
