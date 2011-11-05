" Test Enext and Eprev skipping to first / last file. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)

edit file101.txt
echomsg 'Test: file9998.txt does not exist'
9897Enext
9898Enext
call IsNumAndFile(9999, '9898Enext skipping over 9897 missing numbers')
99999Enext
call IsNumAndFile(41480, '99999Enext skipping over 31480 missing numbers')
echomsg 'Test: file1041479.txt does not exist'
999999Enext

echomsg 'Test: file31481.txt does not exist'
9999Eprev
echomsg 'Test: file20404.txt does not exist'
21076Eprev
21077Eprev
call IsNumAndFile(20403, '21077Eprev skipping over 21076 missing numbers')

edit file41480.txt
41480Eprev
call IsNumAndFile(20000, '41480Eprev skipping over 19999 missing numbers')
echomsg 'Test: file10001.txt does not exist'
9999Eprev
echomsg 'Test: file00000.txt does not exist'
99999Eprev

edit file101.txt
99Eprev
call IsNumAndFile(3, '99Eprev skipping over 97 missing numbers')
edit file101.txt
999Eprev
call IsNumAndFile(3, '999Eprev skipping over 997 missing numbers')
edit file101.txt
99999Eprev
call IsNumAndFile(3, '99999Eprev skipping over 99997 missing numbers')

call vimtest#Quit()

