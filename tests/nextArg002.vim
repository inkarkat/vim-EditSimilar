" Test EditNext and EditPrevious with mismatching glob.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(9)
cd testdata

edit foobar
try
    EditNext file*
    call vimtap#Fail('expected error')
catch
    call vimtap#err#ThrownLike('Cannot locate current file matching file\*: .*[/\\]testdata[/\\]foobar', 'EditNext file* on foobar file')
endtry
call IsNameAndFile('foobar', 'EditNext file* on foobar file')

try
    EditNext foobar
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('This is the sole file in the directory matching foobar', 'EditNext foobar on foobar file')
endtry
call IsNameAndFile('foobar', 'EditNext foobar on foobar file')

try
    EditNext doesnotexist
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No files in this directory matching doesnotexist', 'EditNext doesnotexist on foobar file')
endtry
call IsNameAndFile('foobar', 'EditNext doesnotexist on foobar file')

call vimtest#Quit()
