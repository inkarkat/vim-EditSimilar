" Test EditPlus and EditMinus skipping over large number gaps.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(16)
cd testdata

edit file9999.txt
EditPlus
call IsNumAndFile(20000, 'EditPlus skipping over 10000 missing numbers')
EditPlus
call IsNumAndFile(20403, 'EditPlus skipping over 402 missing numbers')
EditPlus
call IsNumAndFile(41480, 'EditPlus skipping over 21076 missing numbers')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #41481 (from #41480)', 'EditPlus', 'file41481.txt does not exist')
call IsNumAndFile(41480, 'EditPlus does not skip over more than one additional digit')
"call IsNumAndFile(87654321, 'EditPlus does skip over more than one additional digit')

EditMinus
call IsNumAndFile(20403, 'EditMinus skipping over 21076 missing numbers')
EditMinus
call IsNumAndFile(20000, 'EditMinus skipping over 402 missing numbers')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #19999 (from #20000)', 'EditMinus', 'file19999.txt does not exist')
call IsNumAndFile(20000, 'EditMinus keeps 5 digits while skipping over 10000 missing numbers')

call vimtest#Quit()
