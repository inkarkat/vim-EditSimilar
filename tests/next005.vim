" Test Spnext and Spprevious. 

call vimtest#StartTap()
call vimtap#Plan(1)

edit file004.txt
Spnext
1Spnext
Spnext 6
Spnext 999
Spnext 999
Spprev
Spprev! 10
Spprev! 10

call vimtap#window#IsWindows( reverse(map(['004', '005', '006', '011', '101', '100', '090', '080'], '"file" . v:val . ".txt"')), 'split next files')

call vimtest#Quit()

