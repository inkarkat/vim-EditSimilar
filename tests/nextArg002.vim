" Test EditNext and EditPrevious with mismatching glob.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(9)
cd testdata

edit foobar
call vimtap#err#ErrorsLike('Cannot locate current file matching file\*: .*[/\\]testdata[/\\]foobar', 'EditNext file*', 'EditNext file* on foobar file')
call IsNameAndFile('foobar', 'EditNext file* on foobar file')

call vimtap#err#Errors('This is the sole file in the directory matching foobar', 'EditNext foobar', 'EditNext foobar on foobar file')
call IsNameAndFile('foobar', 'EditNext foobar on foobar file')

call vimtap#err#Errors('No files in this directory matching doesnotexist', 'EditNext doesnotexist', 'EditNext doesnotexist on foobar file')
call IsNameAndFile('foobar', 'EditNext doesnotexist on foobar file')

call vimtest#Quit()
