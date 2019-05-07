" Test vertical split via mod.
" Same setup as configsplit002.vim

call vimtest#SkipAndQuitIf(v:version < 704 || v:version == 704 && ! has('patch1898'), 'Need support for <mods>')

let g:EditSimilar_splitmode = 'belowright'
runtime plugin/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit file004.txt
call IsFullHeight()
vertical SplitPlus
call IsFullHeight()
vertical SViewPlus 999
call IsFullHeight()
vertical SplitMinus! 10
call IsFullHeight()

call vimtap#window#IsWindows(map(['004', '005', '101', '091'], '"file" . v:val . ".txt"'), 'belowright vsplit next files')

call vimtest#Quit()
