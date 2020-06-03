if exists("g:wordcount_loaded")
	finish
endif

let g:wordcount_loaded = 1

function! s:set(var, value)
	if !exists(a:var)
		let {a:var} = a:value
	endif
endfunction

" Threshold count to appear in the quickfix window
call s:set("g:wordcount_threshold", 2)

" Ignore letter case
call s:set("g:wordcount_ignore_case", 1)

function! VimWordCountQf(visual) abort
	let l:threshold = g:wordcount_threshold
	let l:ignore_case = g:wordcount_ignore_case
	if type(l:threshold) != type(0)
		throw "Threshold not a number"
	endif
	if type(l:ignore_case) != type(0)
		throw "ignore_case not a number"
	endif
	call s:wordcount(a:visual,
		\ l:threshold,
		\ l:ignore_case)
endfunction

function! s:wordcount(visual, threshold, ignore_case)
	let l:contents = s:contents(a:visual)
	let l:shell_cmd = s:create_shell_cmd(l:contents, a:ignore_case)
	let l:shell_op = systemlist(l:shell_cmd)
	let l:qflist = s:create_qflist(l:shell_op, a:threshold)
	call setqflist(l:qflist, 'r')
endfunction

function! s:contents(visual) abort
	if a:visual == 1
		let [l:vfline, l:vfcol] = getpos("'<")[1:2]
		let [l:vlline, l:vlcol] = getpos("'>")[1:2]
		let l:lines = getline(l:vfline, l:vlline)
		let l:lines[-1] =
			\ l:lines[-1][: l:vlcol -
				\ (&selection == 'inclusive' ? 1 : 2)]
		let l:lines[0] = l:lines[0][l:vfcol - 1:]
	else
		let l:lines = getline(1, line('$'))
	endif
	if len(l:lines) == 0
		throw "No contents"
	endif
	return shellescape(join(l:lines), "\n")
endfunction

function! s:create_shell_cmd(contents, ignore_case)
	if a:ignore_case
		let l:uniq_flags = "-ci"
	else
		let l:uniq_flags = "-c"
	endif
	let l:shell_cmd =
		\ "echo " . a:contents .
		\ " | fmt -1 | grep -oh \"\\b\\w\\+\\b\"" .
		\ " | sort " .
		\ " | uniq " . l:uniq_flags .
		\ " | sort -n"
	return l:shell_cmd
endfunction

function! s:create_qflist(shell_op, threshold)
	let l:qflist = []
	for l:op in a:shell_op
		let l:matches = []
		call substitute(l:op,
			\ '^\s*\(\d\+\)\s*\(.*\)',
			\ '\=extend(l:matches, [submatch(1), submatch(2)])',
			\ 'g')
		let l:count = l:matches[0]
		let l:word = l:matches[1]
		if l:count < a:threshold
			continue
		endif
		call add(l:qflist, {"text": l:op})
	endfor
	return l:qflist
endfunction

nnoremap <silent> <Plug>CountWords
	\ :call VimWordCountQf(0)<cr>
xnoremap <silent> <Plug>CountWords
	\ :call VimWordCountQf(1)<cr>
