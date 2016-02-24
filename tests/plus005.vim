" Test SplitPlus and SplitMinus.

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit file004.txt
SplitPlus
1SplitPlus
SplitPlus 6
SplitPlus 999
SplitPlus 999
SplitMinus
SplitMinus! 10
SplitMinus! 10

call vimtap#window#IsWindows( reverse(map(['004', '005', '006', '011', '101', '100', '090', '080'], '"file" . v:val . ".txt"')), 'split next files')

call vimtest#Quit()
