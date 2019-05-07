" Test SplitPattern to tab via mod.

call vimtest#SkipAndQuitIf(v:version < 704 || v:version == 704 && ! has('patch1898'), 'Need support for <mods>')

call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

edit file100.txt
tab SplitPattern f??b??.txt

call vimtap#Is(1, winnr('$'), 'only one window')
call vimtap#Is(3, tabpagenr(), 'split in new tabs')

call vimtest#Quit()
