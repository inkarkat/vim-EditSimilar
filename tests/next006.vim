" Test EditNext and EditPrevious skipping over number gaps. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(20)

edit file007.txt
echomsg 'Test: file008.txt does not exist'
EditNext 1
call IsNumAndFile(7, 'EditNext 1 to missing file')
EditNext
call IsNumAndFile(9, 'EditNext skipping over missing number')
EditNext
call IsNumAndFile(11, 'EditNext skipping over missing numbers')
EditNext 15
call IsNumAndFile(20, 'EditNext 15 skipping over less than 15 numbers')
EditNext
call IsNumAndFile(30, 'EditNext skipping over missing numbers')

EditPrevious
call IsNumAndFile(20, 'EditPrevious skipping over missing numbers')
EditPrevious 10
call IsNumAndFile(11, 'EditPrevious 10 skipping over less than 10 numbers')
EditPrevious
call IsNumAndFile(9, 'EditPrevious skipping over missing numbers')
echomsg 'Test: file008.txt does not exist'
EditPrevious 1
call IsNumAndFile(9, 'EditPrevious 1 to missing file')
EditPrevious
call IsNumAndFile(7, 'EditPrevious skipping over missing number')

call vimtest#Quit()
