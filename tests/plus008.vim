" Test EditPlus and EditMinus skipping to first / last file.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(20)
cd testdata

edit file101.txt
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #9998 (from #101)', '9897EditPlus', 'file9998.txt does not exist')
9898EditPlus
call IsNumAndFile(9999, '9898EditPlus skipping over 9897 missing numbers')
99999EditPlus
call IsNumAndFile(41480, '99999EditPlus skipping over 31480 missing numbers')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #1041479 (from #41480)', '999999EditPlus', 'file1041479.txt does not exist')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #31481 (from #41480)', '9999EditMinus', 'file31481.txt does not exist')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #20404 (from #41480)', '21076EditMinus', 'file20404.txt does not exist')
21077EditMinus
call IsNumAndFile(20403, '21077EditMinus skipping over 21076 missing numbers')

edit file41480.txt
41480EditMinus
call IsNumAndFile(20000, '41480EditMinus skipping over 19999 missing numbers')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #10001 (from #20000)', '9999EditMinus', 'file10001.txt does not exist')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #00000 (from #20000)', '99999EditMinus', 'file00000.txt does not exist')

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
