" Test EditNext and EditPrevious skipping over large number gaps. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)

edit file9999.txt
EditNext
call IsNumAndFile(20000, 'EditNext skipping over 10000 missing numbers')
EditNext
call IsNumAndFile(20403, 'EditNext skipping over 402 missing numbers')
EditNext
call IsNumAndFile(41480, 'EditNext skipping over 21076 missing numbers')
echomsg 'Test: file41481.txt does not exist'
EditNext
call IsNumAndFile(41480, 'EditNext does not skip over more than one additional digit')
"call IsNumAndFile(87654321, 'EditNext does skip over more than one additional digit')

EditPrevious
call IsNumAndFile(20403, 'EditPrevious skipping over 21076 missing numbers')
EditPrevious
call IsNumAndFile(20000, 'EditPrevious skipping over 402 missing numbers')
echomsg 'Test: file19999.txt does not exist'
EditPrevious
call IsNumAndFile(20000, 'EditPrevious keeps 5 digits while skipping over 10000 missing numbers')

call vimtest#Quit()
