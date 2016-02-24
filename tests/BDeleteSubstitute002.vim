" Test BDeleteSubstitute from different CWD.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(3)
execute 'cd' expand('<sfile>:p:h') . '/testdata'
edit 001/dev/dev001.txt
edit 001/prod/prod001.txt
edit 001/dev/dev002.txt
edit 001/production/prod666.txt

call IsBuffers(['dev001.txt', 'dev002.txt', 'prod001.txt', 'prod666.txt'], 'all buffers')

BDeleteSubstitute 666=001 production=prod
call IsBuffers(['dev001.txt', 'dev002.txt', 'prod666.txt'], 'BDeleteSubstitute from testdata root')

cd $VIM
BDeleteSubstitute production=dev prod=dev 666=002
call IsBuffers(['dev001.txt', 'prod666.txt'], 'BDeleteSubstitute from $VIM')

call vimtest#Quit()
