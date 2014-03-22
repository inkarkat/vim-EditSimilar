" Test EditPlus and EditMinus skipping to first / last file.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)
cd testdata

edit file101.txt
echomsg 'Test: file9998.txt does not exist'
9897EditPlus
9898EditPlus
call IsNumAndFile(9999, '9898EditPlus skipping over 9897 missing numbers')
99999EditPlus
call IsNumAndFile(41480, '99999EditPlus skipping over 31480 missing numbers')
echomsg 'Test: file1041479.txt does not exist'
999999EditPlus

echomsg 'Test: file31481.txt does not exist'
9999EditMinus
echomsg 'Test: file20404.txt does not exist'
21076EditMinus
21077EditMinus
call IsNumAndFile(20403, '21077EditMinus skipping over 21076 missing numbers')

edit file41480.txt
41480EditMinus
call IsNumAndFile(20000, '41480EditMinus skipping over 19999 missing numbers')
echomsg 'Test: file10001.txt does not exist'
9999EditMinus
echomsg 'Test: file00000.txt does not exist'
99999EditMinus

edit file101.txt
99EditMinus
call IsNumAndFile(3, '99EditMinus skipping over 97 missing numbers')
edit file101.txt
999EditMinus
call IsNumAndFile(3, '999EditMinus skipping over 997 missing numbers')
edit file101.txt
99999EditMinus
call IsNumAndFile(3, '99999EditMinus skipping over 99997 missing numbers')

call vimtest#Quit()
