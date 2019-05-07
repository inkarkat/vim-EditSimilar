" Test vertical split via mod.

call vimtest#SkipAndQuitIf(v:version < 704 || v:version == 704 && ! has('patch1898'), 'Need support for <mods>')

call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

edit file004.txt
vertical SplitNext
call IsFullHeight()
SplitNext
call IsFullHeight(0)

call vimtest#Quit()
