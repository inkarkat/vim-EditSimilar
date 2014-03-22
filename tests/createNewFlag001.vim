" Test the check for existing files.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(12)
cd testdata

edit file004.txt
call EditSimilar#Open('edit', 0, 0, 'file004.txt', 'file005.txt', '')
call IsNameAndFile('file005.txt', 'Open file005.txt')

edit file004.txt
echomsg 'Test: no create new'
call EditSimilar#Open('edit', 0, 0, 'file004.txt', 'file00X.txt', '')
call IsNameAndFile('file004.txt', 'Do not open file00X.txt')
echomsg 'Test: no create new with message'
call EditSimilar#Open('edit', 0, 0, 'file004.txt', 'file00X.txt', 'message')
call IsNameAndFile('file004.txt', 'Do not open file00X.txt')

edit file004.txt
echomsg 'Test: no create new without isFilePattern'
call EditSimilar#Open('edit', 0, 0, 'file004.txt', 'file??5.txt', '')
call IsNameAndFile('file004.txt', 'Do not open file??5.txt without isFilePattern')
call EditSimilar#Open('edit', 0, 1, 'file004.txt', 'file??5.txt', '')
call IsNameAndFile('file005.txt', 'Open file??5.txt with isFilePattern')

edit file004.txt
call EditSimilar#Open('edit', 1, 0, 'file004.txt', 'file00X.txt', '')
call IsNameAndNoFile('file00X.txt', 'Open file00X.txt with isCreateNew')

call vimtest#Quit()
