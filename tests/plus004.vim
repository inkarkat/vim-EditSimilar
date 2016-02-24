" Test EditPlus and EditMinus with changing CWDs.
" Tests with :set autochdir, too.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(8)
cd testdata

edit file004.txt
EditPlus
call IsNumAndFile(5, 'EditPlus')
cd ../..
EditPlus
call IsNumAndFile(6, 'EditPlus with cd ../..')
cd $VIM
EditPlus
call IsNumAndFile(7, 'EditPlus with cd $VIM')

if exists('+autochdir')
    set autochdir
endif
EditPlus!
EditPlus
call IsNumAndFile(9, 'EditPlus!, EditPlus with :set autochdir')

call vimtest#Quit()
