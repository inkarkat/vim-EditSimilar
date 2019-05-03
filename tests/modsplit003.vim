" Test split to tab via mod.

call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

edit file004.txt
tab SplitNext

call vimtap#Is(1, winnr('$'), 'only one window')
call vimtap#Is(2, tabpagenr(), 'split in new tab')

call vimtest#Quit()
