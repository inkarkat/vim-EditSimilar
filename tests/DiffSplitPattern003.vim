" Test DiffSplitPattern with unsupported +cmd.

call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit file003.txt

" Tests that the single match is opened, but the +cmd is ignored (well, it is
" treated as a glob and expanded, but there's no result for that).
DiffSplitPattern +setl\ wrap\|quit file01*.txt
call vimtap#window#IsWindows( reverse(['file003.txt', 'file011.txt']), 'DiffSplitPattern file01*.txt')
windo call vimtap#Ok(&l:diff, 'diff enabled')
call vimtap#Is(&l:wrap, 0, 'setting wrap ignored')

call vimtest#Quit()
