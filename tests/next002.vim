" Test EditNext and EditPrevious when exceeding digit width. 

call vimtest#StartTap()
call vimtap#Plan(2)

edit file011.txt
EditNext! 1000
call vimtap#Is(expand('%:t'), 'file1011.txt', 'EditNext! 1000 to four-digit number')
EditPrevious! 12
call vimtap#Is(expand('%:t'), 'file0999.txt', 'EditPrevious! 12 back but keep four-digit number')

call vimtest#Quit()
