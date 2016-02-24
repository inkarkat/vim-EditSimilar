" Test read-only ViewPlus and ViewMinus.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(19)
cd testdata

edit file004.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
ViewPlus
call IsNumAndFile(5, 'ViewPlus')
call vimtap#Ok(&l:readonly, 'ViewPlus is readonly')
ViewPlus 2
call IsNumAndFile(7, '2VSplitPlus')
call vimtap#Ok(&l:readonly, '2VSplitPlus is readonly')


edit file007.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
call vimtap#err#Errors('Substituted file does not exist (add ! to create): #008 (from #007)', '1VSplitPlus', 'file008.txt does not exist')
call IsNumAndFile(7, '1VSplitPlus to missing file')
call vimtap#Ok(! &l:readonly, 'Original after ViewPlus still is not readonly')
ViewPlus!
call IsNumAndNoFile(8, 'ViewPlus! to missing file')
call vimtap#Ok(&l:readonly, 'ViewPlus! is readonly')

edit file020.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
999ViewMinus
call IsNumAndFile(3, '999ViewMinus to first file')
call vimtap#Ok(&l:readonly, '999ViewMinus is readonly')

call vimtest#Quit()
