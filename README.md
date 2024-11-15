EDIT SIMILAR
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Files edited in Vim often relate to one another; maybe they just differ in
file extensions, are numbered sequentially, or contain common patterns. One
can use the built-in cmdline-completion  or filename-modifiers like %:r to
quickly edit a similar file, or even use special plugins, e.g. to alternate
between source and header files ([vimscript #31](http://www.vim.org/scripts/script.php?script_id=31)).

This plugin provides custom versions of
the|:edit|,|:view|,|:split|,|:vsplit|,|:sview|,|:file|,|:write| and|:saveas|
commands which facilitate quick and simple editing of similarly named files.
To quickly edit another file based on the current file, one can:
- substitute {old} with {new}                      EditSimilar-substitutions
- go to previous/next numbered file or                    EditSimilar-offset
  add any offset to the number
- go to succeeding / preceding files in the same directory  EditSimilar-next
- change the file extension                                 EditSimilar-root

To open a set of similar files, it is possible to:
- open all files matching a pattern in split windows     EditSimilar-pattern

### SEE ALSO

- The PatternsOnText.vim plugin ([vimscript #4602](http://www.vim.org/scripts/script.php?script_id=4602)) applies the
  {text}={replacement} of :EditSubstitute via :substitute to the text in the
  buffer with :SubstituteWildcard.

### RELATED WORKS

- altr ([vimscript #4202](http://www.vim.org/scripts/script.php?script_id=4202)) lets you set up custom (per-filetype) rules and then
  opens related files through two forward / backward mappings, e.g. allowing
  you to open the autoload file from the plugin.
- nextfile ([vimscript #4698](http://www.vim.org/scripts/script.php?script_id=4698)) has definitions of related files (like Rails
  controllers, views, model, tests), and can edit a next file via a mapping.
- projectile (https://github.com/tpope/vim-projectile) allows you to define
  per-project settings and navigation commands, e.g. :Eplugin and :Edoc.
- unimpaired.vim ([vimscript #1590](http://www.vim.org/scripts/script.php?script_id=1590)) has (among many other, largely unrelated)
  [f / ]f mappings that work like :EditPrevious / :EditNext.
- vim-headfirst ([vimscript #5749](http://www.vim.org/scripts/script.php?script_id=5749)) has :Hedit, :Hsplit, etc. commands that
  quickly edit "sibling" files from the same directory.

USAGE
------------------------------------------------------------------------------

### SUBSTITUTE
    Change all occurrences via {text}={replacement} in the currently edited file
    (modeled after the Korn shell's "cd {old} {new}" command). This can also be
    achieved with the built-in filename-modifiers:
        :edit %:gs?pattern?replacement?
    but the syntax is difficult to memorize (it's subtly different from :s) and
    harder to type (because one has to use regular expressions instead of the
    simpler file wildcards).

    :EditSubstitute[!] [++opt] [+cmd] {text}={replacement} [{text}={replacement} [...]]

    :ViewSubstitute[!] [++opt] [+cmd] {text}={replacement} [{text}={replacement} [...]]

    :SplitSubstitute[!] [++opt] [+cmd] {text}={replacement} [{text}={replacement} [...]]

    :VSplitSubstitute[!] [++opt] [+cmd] {text}={replacement} [{text}={replacement} [...]]

    :SViewSubstitute[!] [++opt] [+cmd] {text}={replacement} [{text}={replacement} [...]]

    :DiffSplitSubstitute[!] {text}={replacement} [{text}={replacement} [...]]
                            Replaces all literal occurrences of {text} in the
                            currently edited file with {replacement}, and opens the
                            resulting file. If all substitutions can be made on the
                            filename, the pathspec is left alone (so you don't get
                            any false replacements on a long pathspec). Otherwise,
                            the substitutions that weren't applicable to the
                            filename are done to the full absolute pathspec.
                            Finally, substitutions spanning both pathspec and
                            filename are made.

                            By taking advantage of these substitution scopes, you
                            can substitute occurrences in both path and filename
                            by specifying the same substitution twice:
                                /etc/test/superapp/test001.cfg
                                :EditSubstitute test=prod
                                /etc/test/superapp/prod001.cfg
                                :EditSubstitute test=prod test=prod
                                /etc/prod/superapp/prod001.cfg
                            Or perform different substitutions on filename and
                            pathspec:
                                /etc/test/superapp/test001.cfg
                                :EditSubstitute test=prod test=production
                                /etc/production/superapp/prod001.cfg
                            Or across the entire filespec:
                                /etc/test/superapp/test001.cfg
                                :EditSubstitute superapp/test=normalapp/prod
                                /etc/test/normalapp/prod001.cfg

                            Both {text} and {replacement} can include the usual
                            file wildcards (?, *, ** and [...], cp. file-pattern)
                            to save typing; however, the file-pattern must resolve
                            to exactly one filespec, as the underlying Ex commands
                            can only open a single file.
                                /etc/test/superapp/test001.cfg
                                :EditSubstitute test=p* test=p*
                                /etc/production/superapp/prod001.cfg
                                :EditSubstitute **=/tmp [01]=X
                                /tmp/prodXXX.cfg
                            Add [!] to create a new file when the substituted file
                            does not exist.
                            With the special {text}=?{replacement} syntax, you can
                            define optional substitutions that if done don't count
                            yet as a successful substitution; another
                            {text2}={replacement2} must still happen (to edit the
                            file / create a new file with [!]). This allows you to
                            define switch commands that only happen when the
                            crucial substitution can be done, yet still do other
                            adaptations as well.

    :FileSubstitute {text}={replacement} [{text}={replacement} [...]]

    :[range]WriteSubstitute[!] [++opt] {text}={replacement} [{text}={replacement} [...]]

    :SaveSubstitute[!] [++opt] {text}={replacement} [{text}={replacement} [...]]
                            Replaces all occurrences of {text} in the currently
                            edited file with {replacement}, and sets / writes the
                            resulting file. Wildcards can be used here, too.
                            The [!] is needed to overwrite an existing file.

    :BDeleteSubstitute[!] {text}={replacement} [{text}={replacement} [...]]
                            Replaces all occurrences of {text} in the currently
                            edited file with {replacement}, and deletes the
                            resulting buffer. Wildcards can be used here, too.
                            The [!] is needed to delete a changed buffer.

### PLUS MINUS
    Add an offset to the last (decimal) number in the currently edited file.

    :[N]EditPlus[!] [++opt] [+cmd] [N]
    :[N]EditMinus[!] [++opt] [+cmd] [N]

    :[N]ViewPlus[!] [++opt] [+cmd] [N]
    :[N]ViewMinus[!] [++opt] [+cmd] [N]

    :[N]SplitPlus[!] [++opt] [+cmd] [N]
    :[N]SplitMinus[!] [++opt] [+cmd] [N]

    :[N]VSplitPlus[!] [++opt] [+cmd] [N]
    :[N]VSplitMinus[!] [++opt] [+cmd] [N]

    :[N]SViewPlus[!] [++opt] [+cmd] [N]
    :[N]SViewMinus[!] [++opt] [+cmd] [N]

    :[N]DiffSplitPlus[!] [N]
    :[N]DiffSplitMinus[!] [N]
                            Increases / decreases the last number found inside the
                            full absolute filespec of the currently edited file by
                            [N]. This works best on fixed-width numbers which are
                            padded with leading zeros: 001, 011, 123, etc.
                            If a file with that number does not exist, the
                            substitution is retried with larger (no [N]) or
                            smaller ([N] given) offsets, unless [!] is specified.
                            This way, you can easily skip to the last / first
                            numbered file by specifying a sufficiently large [N],
                            (e.g. :99EditPlus), while zooming over gaps in the
                            numbering via a simple :EditPlus.
                            With [!], no skipping over non-existing numbers takes
                            place; instead, a new file is created when the
                            substituted file does not exist.
                            When jumping to previous numbers, the resulting number
                            will never be negative. A jump with [!] and [N] > 1 will
                            create a file with number 1, not 0, but you can still
                            create number 0 by repeating the command with [N] = 1.
                            Examples:
                            test007.txt in a directory also containing 003-013.
                            :EditPlus      -> test008.txt
                            :99EditPlus    -> test013.txt
                            :99EditPlus!   -> test106.txt [New File]
                            :99Eprev       -> test003.txt
                            :99Eprev!      -> test001.txt [New File]
                            :EditPlus      -> test003.txt

    :[N]FilePlus[!] [N]
    :[N]FileMinus[!] [N]

    :[range]WritePlus[!] [++opt] [N]
    :[range]WriteMinus[!] [++opt] [N]

    :[N]SavePlus[!] [++opt] [N]
    :[N]SaveMinus[!] [++opt] [N]
                            Increases / decreases the last number found inside the
                            full absolute filespec of the currently edited file by
                            [N] and sets / writes that file. (A fixed number width
                            via padding with leading zeros is maintained.)
                            When [N] is given and no [!] is given, an existing
                            file with an offset of [N] or smaller is searched, and
                            if such an offset is found, that offset incremented by
                            one is used. This lets you use a large [N] to write
                            the file with the next number within [N] for which no
                            file exists yet.
                            When [!] is given, the file with the added offset is
                            written, plain and simple. [!] is also needed to
                            overwrite an existing file.
                            Examples:
                            test007.txt in a directory also containing 003-013.
                            :WritePlus     -> file exists
                            :WritePlus!    -> test008.txt
                            :WritePlus 99  -> test014.txt [New File]
                            :WritePlus! 99 -> test106.txt [New File]

    :[N]BDeletePlus[!] [N]
    :[N]BDeleteMinus[!] [N]
                            Increases / decreases the last number found inside the
                            full absolute filespec of the currently edited file by
                            [N] and deletes that buffer.

### NEXT PREVIOUS
    In the directory listing of the current file, go to succeeding / preceding
    file entries.

    :[N]EditNext[!] [++opt] [+cmd] [{filelist}]
    :[N]EditPrevious[!] [++opt] [+cmd] [{filelist}]

    :[N]ViewNext[!] [++opt] [+cmd] [{filelist}]
    :[N]ViewPrevious[!] [++opt] [+cmd] [{filelist}]

    :[N]SplitNext[!] [++opt] [+cmd] [{filelist}]
    :[N]SplitPrevious[!] [++opt] [+cmd] [{filelist}]

    :[N]VSplitNext[!] [++opt] [+cmd] [{filelist}]
    :[N]VSplitPrevious[!] [++opt] [+cmd] [{filelist}]

    :[N]SViewNext[!] [++opt] [+cmd] [{filelist}]
    :[N]SViewPrevious[!] [++opt] [+cmd] [{filelist}]

    :[N]DiffSplitNext[!] [{filelist}]
    :[N]DiffSplitPrevious[!] [{filelist}]
                            From the files in the same directory as the current
                            file, go to a succeeding / preceding one. If
                            {filelist} is specified (typically not via separate
                            files, but a file glob like foo*.txt), only those
                            files matching the glob are considered. Otherwise, *
                            is used, i.e. all files not starting with "." are
                            considered. To consider really all files, pass .* *
                            The 'wildignore' setting applies; matching files are
                            ignored, as well as any subdirectories.
                            The order of files is determined by the order in
                            {filelist} and the operating system / file system's
                            resolution of the glob, as elsewhere in Vim.
                            The current buffer must be contained in {filelist} for
                            the commands to work.

    :[N]BDeleteNext[!] [{filelist}]
    :[N]BDeletePrevious[!] [{filelist}]
                            Delete a succeeding / preceding buffer.

### ROOT
    Change the file extension in the currently edited file. This is an enhanced
    version of the built-in:
        :edit %:r.{extension}

    :EditRoot[!] [++opt] [+cmd] {extension}

    :ViewRoot[!] [++opt] [+cmd] {extension}

    :SplitRoot[!] [++opt] [+cmd] {extension}

    :VSplitRoot[!] [++opt] [+cmd] {extension}

    :SViewRoot[!] [++opt] [+cmd] {extension}

    :DiffSplitRoot[!] {extension}
                            Switches the current file's extension:
                            Edits a file with the current file's path and name, but
                            replaces the file extension with the passed one. The
                            leading '.' in {extension} is optional; use either
                            .txt or txt. To get a file without an extension, use .
                                :EditRoot .
                                myfile
                            To replace (or remove) multiple extensions, prepend a
                            . for each one:
                                myfile.txt.bak
                                :EditRoot ..cpp
                                myfile.cpp

                            The {extension} can include the usual file wildcards
                            (?, *, cp. file-pattern) to save typing; however, the
                            file-pattern must resolve to exactly one existing
                            file, as the underlying Ex commands can only open one
                            single file.

                            Add [!] to create a new file when the substituted file
                            does not exist.

    :FileRoot {extension}

    :[range]WriteRoot[!] [++opt] {extension}

    :SaveRoot[!] [++opt] {extension}
                            Sets / saves a file with the current file's path and
                            name, but replaces the file extension with the passed
                            one.
                            The [!] is needed to overwrite an existing file.

    :BDeleteRoot[!] {extension}
                            Deletes a buffer with a different file extension.

### PATTERN
    Open all files matching the file-pattern (actually a file glob) in split
    windows, similar to how |:argadd|{name} adds all matching files to the
    argument list.

    :SplitPattern [++opt] [+cmd] {file-pattern} [{file-pattern} ...]

    :VSplitPattern [++opt] [+cmd] {file-pattern} [{file-pattern} ...]

    :SViewPattern [++opt] [+cmd] {file-pattern} [{file-pattern} ...]

    :DiffSplitPattern {file-pattern} [{file-pattern} ...]
                            Open all files matching {file-pattern} in split windows.
                            If one of the files is already open, no second split is
                            generated.
                            The {file-pattern} can include the usual file wildcards
                            (?, *, cp. file-pattern).
                            Makes all windows the same size if more than one has
                            been opened.

    :BDeletePattern {file-pattern} [{file-pattern} ...]
                            Delete all buffers matching {file-pattern}.

### SUPPORTING COMMANDS

    :SaveOverBufferAs[!] [++opt] {file}
                            Like :saveas, but with [!] also suppresses the
                            E139: "File is loaded in another buffer" error by
                            forcibly deleting the buffer (any unpersisted changes
                            there will be lost). With this plugin, one often
                            (re-)updates similar files that are already loaded in
                            Vim. This command (which is also used in the :Save...
                            commands) avoids the need to issue a separate
                                :BDelete... | Save...

    :[range]WriteOverBuffer[!] [++opt] {file}
                            Like :write, but with [!] also suppresses the
                            E139: "File is loaded in another buffer" error by
                            forcibly deleting the buffer (any unpersisted changes
                            there will be lost). Used in the :Write... commands.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-EditSimilar
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim EditSimilar*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.043 or
  higher.
- Optional, recommended: cmdalias plugin ([vimscript #746](http://www.vim.org/scripts/script.php?script_id=746), or my fork at
  https://github.com/inkarkat/cmdalias.vim)

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

All these edit commands are about speed; after all, they vie to be a faster
alternative to the built-in commands that take a complete filename. Each
user's Vim setup and behavior is different. Therefore, the previously defined
short command forms :Esubst, :Enext, etc. are gone in version 1.20. Instead,
you are encouraged to define your own shortcuts, depending on your preferences
and needs. A great way to do this (because it allows the definition of pure
lowercase commands) is defining short aliases through the cmdalias plugin
([vimscript #74](http://www.vim.org/scripts/script.php?script_id=74), or my fork at https://github.com/inkarkat/cmdalias.vim), like
this:

    " Shorten the most frequently used commands from EditSimilar.vim.
    Alias es  EditSubstitute
    Alias sps SplitSubstitute
    Alias epl EditPlus
    Alias emi EditMinus
    Alias en  EditNext
    Alias ep  EditPrevious
    Alias er  EditRoot
    Alias spr SplitRoot
    Alias spp SplitPattern

All :Split..., :VSplit..., :SView, and :DiffSplit... commands obey the default
'splitbelow' and 'splitright' settings. If you want different behavior, you
can insert the appropriate split modifier command via:

    let g:EditSimilar_splitmode = 'rightbelow'
    let g:EditSimilar_vsplitmode = 'rightbelow'
    let g:EditSimilar_diffsplitmode = 'rightbelow'

IDEAS
------------------------------------------------------------------------------

- Add :EditRecursiveNext / :EditRecursivePrevious to recurse into and out of
  subdirectories.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-EditSimilar/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 2.60    09-Nov-2024
- ENH: Support optional [++opt] [+cmd] for :Edit..., :[S]View..., :[V]Split
  commands and optional [++opt] for :Write... and :Save..., just like the
  original built-in commands they extend.
- FIX: :...Root with escaped file glob characters does not remove the
  backslash on creation.
- Compatibility: After Vim 8.1.1241, a :range outside the number of buffers
  (e.g. :999EditNext) causes an error.
- ENH: Support optional command modifiers (&lt;mods&gt;) prepended to any plugin
  command (but most useful on commands that open in window splits with :tab
  or :botright etc.)
- FIX: Problems when editing or saving files containing a cmdline-special
  character (e.g. #), in particular in :SaveOverBufferAs. Use new
  ingo#escape#file#CmdlineSpecialEscape().
- ENH: Next / previous commands now try again without 'wildignore' option
  before issuing "Cannot locate current file".

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.043!__

##### 2.50    23-Sep-2018
- ENH: Also support optional {text}=?{replacement} that if done don't count
  yet as a successful substitution; another {text2}={replacement2} must still
  happen.
- FIX: :SaveOverBufferAs and :WriteOverBuffer don't handle files with spaces.
  Need to define them with -nargs=+ to keep Vim from unescaping the filespec.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.025!__

##### 2.41    20-Jun-2014
- BUG: :{range}WritePlus 999 doesn't actually work, because it executes as
  999,999WriteOverBuffer.
- Refactoring: Use ingo#fs#path#Exists().
- Use ingo#compat#glob().

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.022!__

##### 2.40    16-Apr-2014
- Add :BDelete... comands, which are especially useful for when "E139: File
  is loaded in another buffer" is given.
- Add :DiffSplit... comands.
- For next files, escape the dirspec for wildcards to handle peculiar
  directories.
- Allow to :write partial buffer contents by defining -range=% on :Write...
  commands that do not yet use the count.
- Add :SaveOverBufferAs and :WriteOverBuffer commands (that with [!] also
  :bdelete an existing buffer with the same name) and use those in the
  :Save... and :Write... commands.
- All commands now properly abort on error.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.018!__

##### 2.32    13-Mar-2014
- Handle dot prefixes (e.g. ".txt") in root completion.
- Also offer multi-extension roots (e.g. ".orig.txt") in root completion, and
  correctly handle existing roots (e.g. ".orig.t").
- Add workaround for editing via :pedit, which uses the CWD of existing
  preview window instead of the CWD of the current window; leading to wrong
  not-existing files being opened when :set autochdir. Work around this by
  always passing a full absolute filespec.

__You need to update to
  ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.017!__

##### 2.31    19-Nov-2013
- Minor: Also handle :echoerr errors, which don't have an E... number
  prepended.
- FIX: Non-any completion can yield duplicate roots, too (e.g. foobar.orig.txt
  + foobar.txt).
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

__You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.014 (or higher)!__

##### 2.30    09-Dec-2012
- CHG: For :FilePlus, :WritePlus, :SavePlus, when a [count] but no [!] is given,
try to create an offset one more than an existing file between the current and
the passed offset. This lets you use a large [N] to write the file with the
next number within [N] for which no file exists yet. Change inspired by
http://stackoverflow.com/questions/13778322/vimscript-code-to-create-a-new-numbered-file

##### 2.20    26-Aug-2012
- Allow passing of multiple {file-pattern} to :SplitPattern et al. and enable
  file completion for them.
- Handle optional ++opt +cmd file options and commands in :SplitPattern et al.

##### 2.10    26-Jul-2012
- ENH: Complete file extensions for any files found in the file's directory for
those commands that most of the time are used to create new files; the default
search for the current filename's extensions won't yield anything there.

##### 2.01    12-Jun-2012
- FIX: To avoid issues with differing forward slash / backslash path separator
components, canonicalize the glob pattern and filespec. This avoids a "Cannot
locate current file" error when there is a mismatch.

##### 2.00    11-Jun-2012
- Rename the :EditNext / :EditPrevious commands to :EditPlus / :EditMinus and
  redefine them to operate on directory contents instead of numerical offsets.
  !!! PLEASE USE THE NEW RENAMED COMMANDS AND
      UPDATE ANY USAGES IN SCRIPTS AND MAPPINGS
  !!!
- Better modularization of the different similarities.
- BUG: Substituted filenames that only exist in an unpersisted Vim buffer
  cause a "file does not exist" error when a:isCreateNew isn't set. Also check
  Vim buffers for a match.

##### 1.22    10-Feb-2012
- ENH: Allow [v]split mode different than determined by 'splitbelow' /
'splitright' via configuration.

##### 1.21    19-Jan-2012 (unreleased)
- Refactoring: Move file extension completion to EditSimilar#Root#Complete() and
create the root commands also in the command builder.

##### 1.20    08-Nov-2011 (unreleased)
- ENH: Omit current buffer's file extension from the completion for
  EditSimilar-root commands.
- Obsolete the short command forms :Esubst, :Enext, :Eprev; the starting
  uppercase letter makes them still awkward to type, there's more likely a
  conflict with other custom commands (e.g. :En -&gt; :Encode, :Enext), and I now
  believe aliasing via cmdalias.vim is the better way to provide personal
  shortcuts, instead of polluting the command namespace with all these
  duplicates.
- Rename :Vsplit... -&gt; :VSplit... and :Sview... -&gt; :SView... as I think this
  is a more intuitive long form. (And now that the user is encouraged to
  create his own custom short aliases, anyway.) The only other plugin with
  similar commands that I know is bufexplorer with its :VSBufExplorer.

##### 1.19    25-Jul-2011
- Avoid that :SplitPattern usually opens splits in reverse glob order (with
default 'nosplitbelow' / 'nosplitright') by forcing :belowright splitting for
all splits after the first. I.e. behave more like vim -o {pattern}.

##### 1.18    22-Jun-2011
- ENH: Implement completion of file extensions for EditSimilar-root commands
like :EditRoot.

##### 1.17    25-Feb-2010
- BUG: :999EditPrevious on 'file00' caused E121: Undefined variable:
l:replacement.

##### 1.16    11-Nov-2009
- BUG: Next / previous commands interpreted files such as 'C406' as hexadecimal.
Thanks to Andy Wokula for sending a patch.

##### 1.15    09-Sep-2009
- Offset commands (:EditNext et al.) now check that the digit pattern does not
accidentally match inside a hexadecimal number (which are unsupported).

##### 1.14    21-Aug-2009
- BF: :[N]EditPrevious with supplied [N] would skip over existing smaller
  number file and would claim that no substituted file existed.
- BF: :[N]EditPrevious with supplied large [N] together with a low original
  number hogs the CPU because the loop iterates over the entire number range
  where the resulting offset would be negative.

##### 1.13    27-Jun-2009
- ENH: :EditNext / :EditPrevious without the optional [count] now skip over gaps
in numbering.

##### 1.12    13-May-2009
- ENH: {text} in :EditSubstitute can now also contain file wildcards (?, \*, \*\*
  and [...]) to save typing.
- ENH: On Windows, {text} in :EditSubstitute can now also use forward slashes
  as path separators (as an alternative to the usual backslashes).
- ENH: Supporting substitutions spanning both pathspec and filename by finally
  applying failed replacements of multi-path elements to the entire filespec.

##### 1.11    11-May-2009
- Added ":ViewSimilar" and ":SviewSimilar" commands to open similar files in
read-only mode.

##### 1.10    23-Feb-2009
- ENH: {replacement} in :EditSubstitute and {extension} in :EditRoot can now
contain file wildcards to save typing.

##### 1.00    18-Feb-2009
- First published version.

##### 0.01    29-Jan-2009
- Started development.

---     20-Jan-2008
Initial implementation sketch of :Sppat and :Vsppat commands.

---     13-Jul-2005
Initial implementation sketch of :Sproot command.

------------------------------------------------------------------------------
Copyright: (C) 2009-2024 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
