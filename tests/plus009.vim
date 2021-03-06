" Test EditPlus with unsupported numbers.

call vimtest#StartTap()
call vimtap#Plan(27)
cd testdata

" Test hexadecimal digits.
let s:negativeFilenames = [
\   'foobar 12AFF0.txt',
\   'foobar 34aff1.txt',
\   '12AFF0.txt',
\   '0x12AFF0',
\   '0x123456',
\   '100CAFEBABE001',
\   '123ABC456DEF',
\   'lot_12AFF012_ex.txt',
\   'not-1E23',
\   'OutlookItem_000000009AC7471490E5C9438F3235912945E5470700242175EA3C8D3045B8D77EE70A063DB500000198B0C0000006B73489FB59244398201E9228CE9E850000001307E60000.txt'
\]
let s:positiveFilenames = [
\   'inside123',
\   '123456',
\   '0y12AFF0',
\   'fox42edition',
\   'notE123',
\   'not-E123',
\   'C406.vim'
\]

for s:filename in s:negativeFilenames
    execute 'edit' ingo#compat#fnameescape(s:filename)
    call vimtap#err#Errors('No number in filespec', 'EditPlus!', 'EditPlus on hexadecimal: ' . s:filename)
    call vimtap#file#IsFilename(s:filename, 'Filename unchanged')
endfor
for s:filename in s:positiveFilenames
    execute 'edit' ingo#compat#fnameescape(s:filename)
    echomsg 'Test: EditPlus on decimal: ' . s:filename
    EditPlus!
    call vimtap#file#IsntFilename(s:filename, 'Filename increased')
endfor

call vimtest#Quit()
