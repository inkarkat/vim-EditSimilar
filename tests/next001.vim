" Test Enext and Eprev. 
" Tests various counts before and after the command. 
" Tests jumping over nonexisting files. 
" Tests creation of new files with !. 
" Tests special minimum number rule for Eprev. 
" Tests that 011 isn't interpreted as octal number (9). 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(38)

edit file004.txt
Enext
call IsNumAndFile(5, 'Enext')
1Enext
call IsNumAndFile(6, '1Enext')
Enext 1
call IsNumAndFile(7, '1Enext')
echomsg 'Test: file008.txt does not exist'
Enext
call IsNumAndFile(7, 'Enext to missing file')
Enext!
call IsNumAndNoFile(8, 'Enext! to missing file')
Enext
call IsNumAndFile(9, 'Enext from missing file')
6Enext
call IsNumAndFile(11, '6Enext')
8Enext
call IsNumAndFile(11, '8Enext no file in range')
10Enext!
call IsNumAndNoFile(21, '10Enext! with no octal interpretation of 011')
999Enext
call IsNumAndFile(101, '999Enext to last file')

Eprev
call IsNumAndFile(100, 'Eprev')
1Eprev!
call IsNumAndNoFile(99, '1Eprev! to missing file')
echomsg 'Test: file039.txt does not exist'
Eprev 60
call IsNumAndNoFile(99, '60Eprev to missing file')
Eprev 70
call IsNumAndFile(30, 'Eprev 70')
999Eprev
call IsNumAndFile(3, '999Eprev to first file')
999Eprev!
call IsNumAndNoFile(1, '999Eprev! to missing first file')
Eprev!
call IsNumAndNoFile(0, 'Eprev! explicitly to number zero')
Enext!
call IsNumAndNoFile(1, 'Enext! to missing first file')
Enext 50
call IsNumAndFile(30, 'Enext 50')

call vimtest#Quit()

