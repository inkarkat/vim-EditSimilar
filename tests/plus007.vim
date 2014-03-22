" Test EditPlus and EditMinus skipping over large number gaps.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)
cd testdata

edit file9999.txt
EditPlus
call IsNumAndFile(20000, 'EditPlus skipping over 10000 missing numbers')
EditPlus
call IsNumAndFile(20403, 'EditPlus skipping over 402 missing numbers')
EditPlus
call IsNumAndFile(41480, 'EditPlus skipping over 21076 missing numbers')
echomsg 'Test: file41481.txt does not exist'
EditPlus
call IsNumAndFile(41480, 'EditPlus does not skip over more than one additional digit')
"call IsNumAndFile(87654321, 'EditPlus does skip over more than one additional digit')

EditMinus
call IsNumAndFile(20403, 'EditMinus skipping over 21076 missing numbers')
EditMinus
call IsNumAndFile(20000, 'EditMinus skipping over 402 missing numbers')
echomsg 'Test: file19999.txt does not exist'
EditMinus
call IsNumAndFile(20000, 'EditMinus keeps 5 digits while skipping over 10000 missing numbers')

call vimtest#Quit()
