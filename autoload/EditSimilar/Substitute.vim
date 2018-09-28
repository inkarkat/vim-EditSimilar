" EditSimilar/Substitute.vim: Custom completion for EditSimilar substitute commands.
"
" DEPENDENCIES:
"   - EditSimilar.vim autoload script
"   - ingo/collections.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/regexp/fromwildcard.vim autoload script
"   - ingo/subst/pairs.vim autoload script
"
" Copyright: (C) 2012-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Substitute commands.
function! s:SplitArgumentsIntoPairs( argumentList )
    let l:pairs = []
    let l:optionalPairs = []
    for l:argument in a:argumentList
	let l:match = matchlist(l:argument, '\(^[^=]\+\)=\(?\?\)\(.*$\)')
	if empty(l:match)
	    throw 'Substitute: Not a substitution: ' . l:argument
	endif
	if l:match[2] ==# '?'
	    call add(l:optionalPairs, [l:match[1], l:match[3]])
	endif
	call add(l:pairs, [l:match[1], l:match[3]])
    endfor
    return [l:pairs, l:optionalPairs]
endfunction
function! EditSimilar#Substitute#Open( opencmd, OptionParser, isCreateNew, filespec, ... )
    let l:originalPathspec = ingo#fs#path#Combine(fnamemodify(a:filespec, ':p:h'), '')
    let l:originalFilename = fnamemodify(a:filespec, ':t')
    let l:originalFilespec = l:originalPathspec . l:originalFilename

    let [l:splitArguments, l:cmdOptions] = [copy(a:000), '']
    if ! empty(a:OptionParser)
	let [l:splitArguments, l:cmdOptions] = call(a:OptionParser, [l:splitArguments])
    endif
    try
	let [l:pairs, l:optionalPairs] = s:SplitArgumentsIntoPairs(l:splitArguments)

	" Try replacement in filename first.
	let [l:replacementFilename, l:failedPairs] = ingo#subst#pairs#Substitute(l:originalFilename, l:pairs, 1)
	let l:replacementFilespec = l:originalPathspec . l:replacementFilename
	let l:replacementMsg = l:replacementFilename
	if ! empty(l:failedPairs)
	    " Then re-try all failed replacements in pathspec.
	    let [l:replacementPathspec, l:failedPairs] = ingo#subst#pairs#Substitute(l:originalPathspec, l:failedPairs, 1)
	    let l:replacementFilespec = l:replacementPathspec . l:replacementFilename
	    let l:replacementMsg = fnamemodify(l:replacementFilespec, ':~:.')
	    if ! empty(l:failedPairs)
		" Finally, apply still failed replacements to the entire
		" (already replaced) filespec, but only if the replacement
		" actually spans a path separator. (To avoid that pathological
		" replacements that should not match now suddenly match in the
		" already done replacements.)
		let [l:attemptedPathPatternPairs, l:failedPairs] = ingo#collections#Partition(l:failedPairs, 'ingo#regexp#fromwildcard#IsWildcardPathPattern(v:val[0])')
		let [l:replacementFilespec, l:failedAttemptedPairs] = ingo#subst#pairs#Substitute(l:replacementFilespec, l:attemptedPathPatternPairs, 1)
		let l:failedPairs += l:failedAttemptedPairs
	    endif
	endif

	if len(l:optionalPairs) > 0
	    " Ensure that not only optional pairs got applied. In that case, the
	    " substitution is deeped inapplicable; at least one non-optional
	    " pair must have been applied.

	    let l:failedNonOptionalPairNum = len(filter(l:failedPairs, 'index(l:optionalPairs, v:val) == -1'))
	    let l:nonOptionalPairNum = len(l:pairs) - len(l:optionalPairs)
	    if l:failedNonOptionalPairNum == l:nonOptionalPairNum
		call ingo#err#Set('Nothing non-optional substituted')
		return 0
	    endif
	endif

	return EditSimilar#Open(a:opencmd, l:cmdOptions, a:isCreateNew, 1, l:originalFilespec, l:replacementFilespec, l:replacementMsg)
    catch /^Substitute:/
	call ingo#err#SetCustomException('Substitute')
	return 0
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
