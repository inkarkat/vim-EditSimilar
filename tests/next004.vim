" Test EditNext and EditPrevious with no files in the directory.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

edit 001/empty/newfile.txt
echomsg 'Test: EditNext'
try
    EditNext
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No files in this directory', 'error')
endtry
call IsNameAndNoFile('newfile.txt', 'EditNext')

try
    EditPrevious
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No files in this directory', 'error')
endtry
call IsNameAndNoFile('newfile.txt', 'EditPrevious')

call vimtest#Quit()
