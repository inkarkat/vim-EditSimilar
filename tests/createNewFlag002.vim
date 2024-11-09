" Test the check for files existing in a buffer only.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit newfile.txt
call setline(1, 'some text')

split file004.txt
call EditSimilar#Open('edit', '', 1, 0, 'file004.txt', 'newfile.txt', '')
call IsNameAndNoFile('newfile.txt', 'Open newfile.txt with isCreateNew')

edit file004.txt
call EditSimilar#Open('edit', '', 0, 0, 'file004.txt', 'newfile.txt', '')
call IsNameAndNoFile('newfile.txt', 'Open newfile.txt without isCreateNew')

call vimtest#Quit()
