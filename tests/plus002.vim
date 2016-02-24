" Test EditPlus and EditMinus when exceeding digit width.

call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

edit file011.txt
EditPlus! 1000
call vimtap#Is(expand('%:t'), 'file1011.txt', 'EditPlus! 1000 to four-digit number')
EditMinus! 12
call vimtap#Is(expand('%:t'), 'file0999.txt', 'EditMinus! 12 back but keep four-digit number')

call vimtest#Quit()
