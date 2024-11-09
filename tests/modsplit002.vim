" Test splitbelow via mod.

call vimtest#SkipAndQuitIf(v:version < 704 || v:version == 704 && ! has('patch1898'), 'Need support for <mods>')

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit file004.txt
belowright SplitNext
SplitNext
botright SplitNext

call vimtap#window#IsWindows(map(['004', '006', '005', '007'], '"file" . v:val . ".txt"'), 'SplitNext')

call vimtest#Quit()
