" Test EditNext and EditPrevious. 
" Tests various counts before and after the command. 
" Tests jumping over nonexisting files. 
" Tests creation of new files with !. 
" Tests special minimum number rule for EditPrevious. 
" Tests that 011 isn't interpreted as octal number (9). 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(38)

edit file004.txt
EditNext
call IsNumAndFile(5, 'EditNext')
1EditNext
call IsNumAndFile(6, '1EditNext')
EditNext 1
call IsNumAndFile(7, '1EditNext')
echomsg 'Test: file008.txt does not exist'
1EditNext
call IsNumAndFile(7, '1EditNext to missing file')
EditNext!
call IsNumAndNoFile(8, 'EditNext! to missing file')
EditNext
call IsNumAndFile(9, 'EditNext from missing file')
6EditNext
call IsNumAndFile(11, '6EditNext')
8EditNext
call IsNumAndFile(11, '8EditNext no file in range')
10EditNext!
call IsNumAndNoFile(21, '10EditNext! with no octal interpretation of 011')
999EditNext
call IsNumAndFile(101, '999EditNext to last file')

EditPrevious
call IsNumAndFile(100, 'EditPrevious')
1EditPrevious!
call IsNumAndNoFile(99, '1EditPrevious! to missing file')
echomsg 'Test: file039.txt does not exist'
EditPrevious 60
call IsNumAndNoFile(99, '60EditPrevious to missing file')
EditPrevious 70
call IsNumAndFile(30, 'EditPrevious 70')
999EditPrevious
call IsNumAndFile(3, '999EditPrevious to first file')
999EditPrevious!
call IsNumAndNoFile(1, '999EditPrevious! to missing first file')
EditPrevious!
call IsNumAndNoFile(0, 'EditPrevious! explicitly to number zero')
EditNext!
call IsNumAndNoFile(1, 'EditNext! to missing first file')
EditNext 50
call IsNumAndFile(30, 'EditNext 50')

call vimtest#Quit()
