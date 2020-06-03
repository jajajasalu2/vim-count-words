# vim-count-words

Display the count for every word in the current buffer.

### Why?

I find it useful to:

- Detect duplicate words and do what I want that info.
- Get a gist of what a file/module is about.

### Usage

`vim-count-words` provides the `<Plug>CountWords` mapping. Map it however you
want to. Example:

```
map <leader>gc <Plug>CountWords
```

Upon using the binding, you'll have to open the quickfix window to
display the results, as so:

```
:copen
```

### Settings

`g:wordcount_threshold` is used for setting a lower limit of the word count for
a word to be displayed. By default it is `2`. For example:

```
let g:wordcount_threshold = 2
```

`g:wordcount_ignore_case` is used for ignoring the case of the words. By
default it is `1`, i.e., the case is ignored. If `0`, the case will not be
ignored. For example:

```
let g:wordcount_ignore_case = 1
```

### Installation

Use your favorite plugin manager. For
[vim-plug](https://github.com/junegunn/vim-plug):

```
Plug 'jajajasalu2/vim-count-words'
```

### TODO

- [ ] Write test cases
- [ ] Enable CI/CD
- [X] Take care of exception handling
- [ ] Add a command, enable passing in user
      args to override default (`g:`) settings
- [ ] Add an ignore words list setting?
- [ ] Look into compatibility issues with Windows/Mac OS, resolve if any
- [ ] Write help files to read from Vim

### License

MIT
