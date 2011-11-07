" Test SplitSubstitute on entire filespec. 

call vimtest#StartTap()
call vimtap#Plan(1)

edit file001.txt
SplitSubstitute file=001/dev/dev
SplitSubstitute dev=prod dev=prod
SplitSubstitute /prod=/production dev=prod 001=666
SplitSubstitute 001/production/= 001/production/= prod= 666=file100
SplitSubstitute! file=FILE 100=999
call vimtap#window#IsWindows( reverse(['file001.txt', '001/dev/dev001.txt', '001/prod/prod001.txt', '001/production/prod666.txt', 'file100.txt', 'FILE999.txt']), 'SplitSubstitute foo files')

call vimtest#Quit()
