" Test vsplit configuration. 

let g:EditSimilar_splitmode = 'vertical belowright'
let g:EditSimilar_vsplitmode = 'belowright'
runtime plugin/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(1)

edit file004.txt
VSplitNext
SViewNext 999
VSplitPrevious! 10

call vimtap#window#IsWindows( map(['004', '005', '101', '091'], '"file" . v:val . ".txt"'), 'belowright vsplit next files')

call vimtest#Quit()
