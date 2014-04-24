" Test completion used by EditRoot.

call vimtest#StartTap()
call vimtap#Plan(7)
cd testdata

edit foobar.txt
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), ['cpp', 'orig.txt'], 'complete from foobar.txt')
call vimtap#Is(EditSimilar#Root#Complete('t', '', 1), [], 'complete t from foobar.txt')
edit fXXbaz.txt
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), [], 'complete from fXXbaz.txt')
edit lala.txt
call vimtap#Is(EditSimilar#Root#Complete('', '', 1), ['desc', 'description', 'install'], 'complete from lala.txt')
call vimtap#Is(EditSimilar#Root#Complete('d', '', 1), ['desc', 'description'], 'complete d from lala.txt')
call vimtap#Is(EditSimilar#Root#Complete('in', '', 1), ['install'], 'complete in from lala.txt')
call vimtap#Is(EditSimilar#Root#Complete('int', '', 1), [], 'complete int from lala.txt')

call vimtest#Quit()
