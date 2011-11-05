" Test Esubst with file wildcards in the text part spanning directories. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(5)

" Tests that the ? wildcard does not span directories. 
execute 'cd' expand('<sfile>:p:h') 
edit 001/prod/prod001.txt
Esubst 001=666 ?prod=/production
call vimtap#file#IsFilespec('001/prod/prod001.txt', '001/prod/prod001 -> Esubst ?= H> 001/production/prod666')

" Tests that the * wildcard does not span directories. 
execute 'cd' expand('<sfile>:p:h') 
edit 001/production/prod666.txt
Esubst *duction=prod 666=001
call vimtap#file#IsFilespec('001/prod/prod001.txt', '001/production/prod666 -> Esubst *= -> 001/prod/prod001')
call vimtap#file#IsFile('001/production/prod666 -> Esubst *= => 001/prod/prod001')

" Tests that the [ch] wildcard does not span directories. 
execute 'cd' expand('<sfile>:p:h') 
edit 001/prod/prod001.txt
Esubst 001=666 [/\\]prod=/production
call vimtap#file#IsFilespec('001/prod/prod001.txt', '001/prod/prod001 -> Esubst []= H> 001/production/prod666')

" Tests that the [^ch] wildcard does not span directories. 
execute 'cd' expand('<sfile>:p:h') 
edit 001/prod/prod001.txt
Esubst 001=666 [^x]prod=/production
call vimtap#file#IsFilespec('001/prod/prod001.txt', '001/prod/prod001 -> Esubst [^]= H> 001/production/prod666')

call vimtest#Quit()

