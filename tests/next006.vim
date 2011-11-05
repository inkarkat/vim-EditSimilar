" Test Enext and Eprev skipping over number gaps. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(20)

edit file007.txt
echomsg 'Test: file008.txt does not exist'
Enext 1
call IsNumAndFile(7, 'Enext 1 to missing file')
Enext
call IsNumAndFile(9, 'Enext skipping over missing number')
Enext
call IsNumAndFile(11, 'Enext skipping over missing numbers')
Enext 15
call IsNumAndFile(20, 'Enext 15 skipping over less than 15 numbers')
Enext
call IsNumAndFile(30, 'Enext skipping over missing numbers')

Eprev
call IsNumAndFile(20, 'Eprev skipping over missing numbers')
Eprev 10
call IsNumAndFile(11, 'Eprev 10 skipping over less than 10 numbers')
Eprev
call IsNumAndFile(9, 'Eprev skipping over missing numbers')
echomsg 'Test: file008.txt does not exist'
Eprev 1
call IsNumAndFile(9, 'Eprev 1 to missing file')
Eprev
call IsNumAndFile(7, 'Eprev skipping over missing number')

call vimtest#Quit()

