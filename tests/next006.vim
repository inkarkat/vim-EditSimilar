" Test EditNext and EditPrevious skipping of wildignore matches.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

set wildignore=*.description,lala.txt
edit lala.desc
EditNext
call IsNameAndFile('lala.install', 'EditNext')
try
    EditNext
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No next file', 'error')
endtry
call IsNameAndFile('lala.install', 'EditNext')

call vimtest#Quit()
