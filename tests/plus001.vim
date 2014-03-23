" Test EditPlus and EditMinus.
" Tests various counts before and after the command.
" Tests jumping over nonexisting files.
" Tests creation of new files with !.
" Tests special minimum number rule for EditMinus.
" Tests that 011 isn't interpreted as octal number (9).

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(41)
cd testdata

edit file004.txt
EditPlus
call IsNumAndFile(5, 'EditPlus')
1EditPlus
call IsNumAndFile(6, '1EditPlus')
EditPlus 1
call IsNumAndFile(7, '1EditPlus')
try
    1EditPlus
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Substituted file does not exist (add ! to create): #008 (from #007)', 'file008.txt does not exist')
endtry
call IsNumAndFile(7, '1EditPlus to missing file')
EditPlus!
call IsNumAndNoFile(8, 'EditPlus! to missing file')
EditPlus
call IsNumAndFile(9, 'EditPlus from missing file')
6EditPlus
call IsNumAndFile(11, '6EditPlus')
try
    8EditPlus
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Substituted file does not exist (add ! to create): #019 (from #011)', 'file019.txt does not exist')
endtry
call IsNumAndFile(11, '8EditPlus no file in range')
10EditPlus!
call IsNumAndNoFile(21, '10EditPlus! with no octal interpretation of 011')
999EditPlus
call IsNumAndFile(101, '999EditPlus to last file')

EditMinus
call IsNumAndFile(100, 'EditMinus')
1EditMinus!
call IsNumAndNoFile(99, '1EditMinus! to missing file')
try
    EditMinus 60
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Substituted file does not exist (add ! to create): #039 (from #099)', 'file039.txt does not exist')
endtry
call IsNumAndNoFile(99, '60EditMinus to missing file')
EditMinus 70
call IsNumAndFile(30, 'EditMinus 70')
999EditMinus
call IsNumAndFile(3, '999EditMinus to first file')
999EditMinus!
call IsNumAndNoFile(1, '999EditMinus! to missing first file')
EditMinus!
call IsNumAndNoFile(0, 'EditMinus! explicitly to number zero')
EditPlus!
call IsNumAndNoFile(1, 'EditPlus! to missing first file')
EditPlus 50
call IsNumAndFile(30, 'EditPlus 50')

call vimtest#Quit()
