" Test SplitNext and SplitPrevious. 

call vimtest#StartTap()
call vimtap#Plan(1)

edit file004.txt
SplitNext
1SplitNext
SplitNext 6
SplitNext 999
SplitNext 999
SplitPrevious
SplitPrevious! 10
SplitPrevious! 10

call vimtap#window#IsWindows( reverse(map(['004', '005', '006', '011', '101', '100', '090', '080'], '"file" . v:val . ".txt"')), 'split next files')

call vimtest#Quit()
