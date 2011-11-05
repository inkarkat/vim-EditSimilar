" Test Enext and Eprev skipping over large number gaps. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)

edit file9999.txt
Enext
call IsNumAndFile(20000, 'Enext skipping over 10000 missing numbers')
Enext
call IsNumAndFile(20403, 'Enext skipping over 402 missing numbers')
Enext
call IsNumAndFile(41480, 'Enext skipping over 21076 missing numbers')
echomsg 'Test: file41481.txt does not exist'
Enext
call IsNumAndFile(41480, 'Enext does not skip over more than one additional digit')
"call IsNumAndFile(87654321, 'Enext does skip over more than one additional digit')

Eprev
call IsNumAndFile(20403, 'Eprev skipping over 21076 missing numbers')
Eprev
call IsNumAndFile(20000, 'Eprev skipping over 402 missing numbers')
echomsg 'Test: file19999.txt does not exist'
Eprev
call IsNumAndFile(20000, 'Eprev keeps 5 digits while skipping over 10000 missing numbers')

call vimtest#Quit()

