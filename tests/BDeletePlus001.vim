" Test BDeletePlus.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit lala.txt
edit file100.txt
edit file005.txt
edit file004.txt
call IsBuffers(['file004.txt', 'file005.txt', 'file100.txt', 'lala.txt'], 'all buffers')

BDeletePlus
call IsBuffers(['file004.txt', 'file100.txt', 'lala.txt'], 'BDeletePlus')

try
    999BDeletePlus
    call vimtap#Fail('expected exception')
catch
    call vimtap#err#ThrownLike('^E94: .* file1003.txt', 'No matching buffer')
endtry
call IsBuffers(['file004.txt', 'file100.txt', 'lala.txt'], '999BDeletePlus')

96BDeletePlus
call IsBuffers(['file004.txt', 'lala.txt'], '96BDeletePlus')

call vimtest#Quit()
