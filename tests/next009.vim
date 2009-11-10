" Test Enext with unsupported numbers. 

call vimtest#StartTap()
call vimtap#Plan(14)

" Test hexadecimal digits. 
let s:negativeFilenames = [
\   'foobar 12AFF0.txt',
\   'foobar 34aff1.txt',
\   '12AFF0.txt',
\   '0x12AFF0',
\   '100CAFEBABE001',
\   '123ABC456DEF',
\   'lot_12AFF012_ex.txt',
\   'not-E123',
\   'OutlookItem_000000009AC7471490E5C9438F3235912945E5470700242175EA3C8D3045B8D77EE70A063DB500000198B0C0000006B73489FB59244398201E9228CE9E850000001307E60000.txt'
\]
let s:positiveFilenames = [
\   'inside123',
\   '123456',
\   '0y12AFF0',
\   'fox42edition',
\   'notE123'
\]

for s:filename in s:negativeFilenames
    execute 'edit' escapings#fnameescape(s:filename)
    echomsg 'Test: Enext on hexadecimal: ' . s:filename
    Enext!
    call vimtap#file#IsFilename(s:filename, 'Filename unchanged')
endfor
for s:filename in s:positiveFilenames
    execute 'edit' escapings#fnameescape(s:filename)
    echomsg 'Test: Enext on decimal: ' . s:filename
    Enext!
    call vimtap#file#IsntFilename(s:filename, 'Filename increased')
endfor

call vimtest#Quit()

