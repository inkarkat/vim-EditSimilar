" Test EditNext and EditPrevious skipping to first / last file. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)

edit file101.txt
echomsg 'Test: file9998.txt does not exist'
9897EditNext
9898EditNext
call IsNumAndFile(9999, '9898EditNext skipping over 9897 missing numbers')
99999EditNext
call IsNumAndFile(41480, '99999EditNext skipping over 31480 missing numbers')
echomsg 'Test: file1041479.txt does not exist'
999999EditNext

echomsg 'Test: file31481.txt does not exist'
9999EditPrevious
echomsg 'Test: file20404.txt does not exist'
21076EditPrevious
21077EditPrevious
call IsNumAndFile(20403, '21077EditPrevious skipping over 21076 missing numbers')

edit file41480.txt
41480EditPrevious
call IsNumAndFile(20000, '41480EditPrevious skipping over 19999 missing numbers')
echomsg 'Test: file10001.txt does not exist'
9999EditPrevious
echomsg 'Test: file00000.txt does not exist'
99999EditPrevious

edit file101.txt
99EditPrevious
call IsNumAndFile(3, '99EditPrevious skipping over 97 missing numbers')
edit file101.txt
999EditPrevious
call IsNumAndFile(3, '999EditPrevious skipping over 997 missing numbers')
edit file101.txt
99999EditPrevious
call IsNumAndFile(3, '99999EditPrevious skipping over 99997 missing numbers')

call vimtest#Quit()
