" Test split configuration.

let g:EditSimilar_splitmode = 'belowright'
runtime plugin/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit file004.txt
SplitPlus
SViewPlus 999
SplitMinus! 10

call vimtap#window#IsWindows( map(['004', '005', '101', '091'], '"file" . v:val . ".txt"'), 'belowright split next files')

call vimtest#Quit()
