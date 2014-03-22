" Test EditPlus and EditMinus skipping over number gaps.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(20)
cd testdata

edit file007.txt
echomsg 'Test: file008.txt does not exist'
EditPlus 1
call IsNumAndFile(7, 'EditPlus 1 to missing file')
EditPlus
call IsNumAndFile(9, 'EditPlus skipping over missing number')
EditPlus
call IsNumAndFile(11, 'EditPlus skipping over missing numbers')
EditPlus 15
call IsNumAndFile(20, 'EditPlus 15 skipping over less than 15 numbers')
EditPlus
call IsNumAndFile(30, 'EditPlus skipping over missing numbers')

EditMinus
call IsNumAndFile(20, 'EditMinus skipping over missing numbers')
EditMinus 10
call IsNumAndFile(11, 'EditMinus 10 skipping over less than 10 numbers')
EditMinus
call IsNumAndFile(9, 'EditMinus skipping over missing numbers')
echomsg 'Test: file008.txt does not exist'
EditMinus 1
call IsNumAndFile(9, 'EditMinus 1 to missing file')
EditMinus
call IsNumAndFile(7, 'EditMinus skipping over missing number')

call vimtest#Quit()
