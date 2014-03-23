" Test EditNext and EditPrevious with non-existing file.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

edit newfile.txt
try
    EditNext
    call vimtap#Fail('expected error')
catch
    call vimtap#err#ThrownLike('Cannot locate current file: .*[/\\]testdata[/\\]newfile.txt', 'error')
endtry
call IsNameAndNoFile('newfile.txt', 'EditNext')

try
    EditPrevious
catch
    call vimtap#err#ThrownLike('Cannot locate current file: .*[/\\]testdata[/\\]newfile.txt', 'error')
endtry
call IsNameAndNoFile('newfile.txt', 'EditPrevious')

call vimtest#Quit()
