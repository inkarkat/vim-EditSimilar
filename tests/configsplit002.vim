" Test vsplit configuration.

let g:EditSimilar_splitmode = 'vertical belowright'
let g:EditSimilar_vsplitmode = 'belowright'
runtime plugin/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit file004.txt
call IsFullHeight()
VSplitPlus
call IsFullHeight()
SViewPlus 999
call IsFullHeight()
VSplitMinus! 10
call IsFullHeight()

call vimtap#window#IsWindows(map(['004', '005', '101', '091'], '"file" . v:val . ".txt"'), 'belowright vsplit next files')

call vimtest#Quit()
