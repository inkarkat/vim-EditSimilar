" Test EditNext and EditPrevious with changing CWDs. 
" Tests with :set autochdir, too. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(8)

edit file004.txt
EditNext
call IsNumAndFile(5, 'EditNext')
cd ../..
EditNext
call IsNumAndFile(6, 'EditNext with cd ../..')
cd $VIM
EditNext
call IsNumAndFile(7, 'EditNext with cd $VIM')

if exists('&autochdir')
    set autochdir
endif
EditNext!
EditNext
call IsNumAndFile(9, 'EditNext!, EditNext with :set autochdir')

call vimtest#Quit()
