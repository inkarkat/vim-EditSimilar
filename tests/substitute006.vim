" Test Spsubst on entire filespec. 

call vimtest#StartTap()
call vimtap#Plan(1)

edit file001.txt
Spsubst file=001/dev/dev
Spsubst dev=prod dev=prod
Spsubst /prod=/production \prod=\production dev=prod 001=666
Spsubst 001/production/= 001\production\= prod= 666=file100
Spsubst! file=FILE 100=999
call vimtap#window#IsWindows( reverse(['file001.txt', '001/dev/dev001.txt', '001/prod/prod001.txt', '001/production/prod666.txt', 'file100.txt', 'FILE999.txt']), 'Spsubst foo files')

call vimtest#Quit()

