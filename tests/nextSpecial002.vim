" Test EditNext with filelist containing space

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(9)
cd testdata

" Tests dotfiles and contained (escaped) spaces.
edit 001/special/.foo\ bar.txt
4EditNext .*\ bar.txt *\ bar.txt
call IsNameAndFile('foo bar.txt', '4EditNext .*\ bar.txt *\ bar.txt')

" Tests escaping of leading + (interpreted as +cmd otherwise) as [+] and of
" special #.
edit 001/special/\#foo\ bar.txt
EditPrevious [+]foo\ bar.txt \#foo\ bar.txt
call IsNameAndFile('+foo bar.txt', 'EditPrevious [+]foo\ bar.txt \#foo\ bar.txt')

" Tests spaces in glob and error message.
edit 001/special/+foo\ bar.txt
EditNext [+=]foo\ b* doesN*tExist
call IsNameAndFile('=foo bar.txt', 'EditNext [+=]foo\ b* doesN*tExist')
call vimtap#err#Errors('No next file matching [+=]foo b* or doesN*tExist', 'EditNext [+=]foo\ b* doesN*tExist', 'error')
call IsNameAndFile('=foo bar.txt', 'EditNext [+=]foo\ b* doesN*tExist on last file')

call vimtest#Quit()
