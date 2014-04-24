" Test EditNext and EditPrevious with changing CWDs.
" Tests with :set autochdir, too.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(20)
cd testdata

edit file004.txt
EditNext
call IsNameAndFile('file005.txt', 'EditNext')
cd ../..
EditNext
call IsNameAndFile('file006.txt', 'EditNext with cd ../..')
999EditNext
call IsNameAndFile('lala.txt', '999EditNext to last file with cd ../..')
999EditPrevious
call IsNameAndFile('fXXbaz.txt', '999EditPrevious to first file with cd ../..')


cd $VIM
execute 'edit' expand('<sfile>:p:h') . '/testdata/file005.txt'
EditNext
call IsNameAndFile('file006.txt', 'EditNext with cd $VIM')
999EditNext
call IsNameAndFile('lala.txt', '999EditNext to last file with cd $VIM')
999EditPrevious
call IsNameAndFile('fXXbaz.txt', '999EditPrevious to first file with cd $VIM')


execute 'edit' expand('<sfile>:p:h') . '/testdata/file005.txt'
if exists('+autochdir')
    set autochdir
endif
EditNext
call IsNameAndFile('file006.txt', 'EditNext with :set autochdir')
999EditNext
call IsNameAndFile('lala.txt', '999EditNext to last file with :set autochdir')
999EditPrevious
call IsNameAndFile('fXXbaz.txt', '999EditPrevious to first file with :set autochdir')

call vimtest#Quit()
