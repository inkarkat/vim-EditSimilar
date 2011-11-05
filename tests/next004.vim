" Test Enext and Eprev with changing CWDs. 
" Tests with :set autochdir, too. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(8)

edit file004.txt
Enext
call IsNumAndFile(5, 'Enext')
cd ../..
Enext
call IsNumAndFile(6, 'Enext with cd ../..')
cd $VIM
Enext
call IsNumAndFile(7, 'Enext with cd $VIM')

if exists('&autochdir')
    set autochdir
endif
Enext!
Enext
call IsNumAndFile(9, 'Enext!, Enext with :set autochdir')

call vimtest#Quit()

