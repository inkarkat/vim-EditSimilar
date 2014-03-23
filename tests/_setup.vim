if g:runVimTest !~# 'config\w*\d\+'
    " Do not yet source the plugins for the configuration tests.
    runtime plugin/EditSimilar.vim
endif
