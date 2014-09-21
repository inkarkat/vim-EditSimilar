if g:runVimTest !~# 'config\w*\d\+'
    " Do not yet source the plugins for the configuration tests.
    runtime plugin/EditSimilar.vim
endif

let s:expectedTestdata = ['001', 'fCCbaz.txt', 'file003.txt', 'file004.txt', 'file005.txt', 'file006.txt', 'file007.txt', 'file009.txt', 'file011.txt', 'file020.txt', 'file030.txt', 'file100.txt', 'file101.txt', 'file20000.txt', 'file20403.txt', 'file41480.txt', 'file87654321.txt', 'file9999.txt', 'file[abc].txt', 'fino[^abc].txt', 'foobar', 'foobar.cpp', 'foobar.orig.txt', 'foobar.txt', 'lala.desc', 'lala.description', 'lala.install', 'lala.txt']
let s:actualTestdata = map(split(glob('testdata/*'), '\n'), 'fnamemodify(v:val, ":t")')
if sort(copy(s:actualTestdata)) !=# sort(copy(s:expectedTestdata))
    call vimtest#BailOut('Testdata has been contaminated')
endif
if s:actualTestdata !=# s:expectedTestdata
    echomsg '****' string(s:actualTestdata)
    echomsg '****' string(s:expectedTestdata)
    call vimtest#BailOut('Testdata glob is sorted wrong')
endif
