" cmd-fontsize.vim
"
"    Author: James A. Shackleford <shack@linux.com>
"   Updated: July 13th, 2015
"
"   Some simple functions that provide complete control
"   over the font size in gVim.  Accompanying vim commands
"   save a little typing.
"
""""""""""""""""

" Some people don't set guifont in their vimrc file!
if empty(&guifont)
    let &guifont = getfontname()
endif

" Bound the font size within a sane range
let g:FontSizeMin = 6
let g:FontSizeMax = 48
let s:FontSizeOrig = substitute(&guifont, '^\(.* \)\([1-9][0-9]*\)$', '\2', '')

" The FontSize() function reports the current font size if no argument is
" supplied.  Supplying a numerical argument changes the font size.
function! FontSize(...)
    if has("gui_gtk2") && has("gui_running")
        if (a:0 > 0)
            let l:font_name = substitute(&guifont, '^\(.* \)\([1-9][0-9]*\)$', '\1', '')
            if (a:1 < g:FontSizeMin)
                echom "Warning -- Font size (".a:1.") too small.  Min: ".g:FontSizeMin
            elseif (a:1 > g:FontSizeMax)
                echom "Warning -- Font size (".a:1.") too large.  Max: ".g:FontSizeMax
            else
                let &guifont = l:font_name.a:1
            endif
        else
            let l:current_size = substitute(&guifont, '^\(.* \)\([1-9][0-9]*\)$', '\2', '')
            echom "FontSize = ".l:current_size
            return l:current_size
        endif
    else
        echom "Warning -- FontSize can only be used in gVim."
    endif
endfunction
command! -nargs=* FontSize call FontSize(<f-args>)


" Adjust the current font size by the argument provided.  If no argument is
" provided, the font size remains unchanged.  Font size can be incremented by
" supplying a positive number and decremented by supplying a negative number.
function! FontAdjust(...)
    let l:increment = 0
    if (a:0 > 0)
        let l:increment = a:1
    endif

    let l:current_size = FontSize()
    call FontSize(l:current_size + l:increment)
endfunction
command! -nargs=* FontAdjust call FontAdjust(<f-args>)


" Set the font size back to whatever is defined in gvimrc
function! FontDefaultSize()
    call FontSize(s:FontSizeOrig)
endfunction
command! -nargs=0 FontDefaultSize call FontDefaultSize()
