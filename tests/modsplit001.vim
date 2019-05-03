" Test vertical split via mod.

call vimtest#StartTap()
call vimtap#Plan(0)
cd testdata

edit file004.txt
vertical SplitNext
call IsFullHeight()
SplitNext
call IsFullHeight(0)

call vimtest#Quit()
