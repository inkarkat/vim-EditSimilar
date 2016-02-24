" Test FilePlus and FileMinus.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(18)
cd testdata

" Tests creating a new next file without [count].
edit file007.txt
FilePlus
call IsNumAndNoFile(8, 'FilePlus')

" Tests creating a search for next new file with [count].
edit file007.txt
50FilePlus
call IsNumAndNoFile(31, '50FilePlus')

" Tests no search when the file at the offset (and above it) exists.
edit file007.txt
93FilePlus
call IsNumAndFile(100, '93FilePlus')

" Tests no search when the file at the offset and below it exists.
edit file007.txt
94FilePlus
call IsNumAndFile(101, '94FilePlus')

" Tests creating a search for next new file with [count] that finds one below it.
edit file007.txt
95FilePlus
call IsNumAndNoFile(102, '95FilePlus')

" Tests creating a search for next new file with [count] that finds two below it.
edit file007.txt
96FilePlus
call IsNumAndNoFile(102, '96FilePlus')

" Tests forcing a new file creation with [!].
edit file007.txt
96FilePlus!
call IsNumAndNoFile(103, '96FilePlus!')

" Tests finding the previous file without [count].
edit file007.txt
FileMinus
call IsNumAndFile(6, 'FileMinus')

" Tests creating a search for previous new file with [count].
edit file007.txt
FileMinus 9
call IsNumAndNoFile(2, 'FileMinus 9')

call vimtest#Quit()
