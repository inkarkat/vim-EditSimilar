" Test Enext and Eprev when exceeding digit width. 

call vimtest#StartTap()
call vimtap#Plan(2)

edit file011.txt
Enext! 1000
call vimtap#Is(expand('%:t'), 'file1011.txt', 'Enext! 1000 to four-digit number')
Eprev! 12
call vimtap#Is(expand('%:t'), 'file0999.txt', 'Eprev! 12 back but keep four-digit number')

call vimtest#Quit()

