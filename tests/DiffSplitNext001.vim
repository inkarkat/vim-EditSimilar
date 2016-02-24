" Test DiffSplitNext.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(3)
cd testdata

edit file004.txt
DiffSplitNext
call vimtap#window#IsWindows( reverse(map(['004', '005'], '"file" . v:val . ".txt"')), 'DiffSplitNext')
windo call vimtap#Ok(&l:diff, 'diff enabled')

call vimtest#Quit()
