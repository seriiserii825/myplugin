nvim-git-open 
==============

A simple plugin to open current github or bitbucket project in browser

Installation
------------

Use your favorite plugin manager.

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'seriiserii825/nvim-git-open'
```

Quick start guide
-----------------

Add the following mappings to your .vimrc.

By default is using `<leader>gp` to open git project and `<leader>gf` to open git file.

```vim
" Open git project folder
nmap <leader>gp :OpenGitProject<CR><CR>

" Open git file
nmap <leader>gf :OpenGitProjectFile<CR><CR>
```

Author
------

[Burduja Sergiu](https://github.com/seriiserii825)

License
-------

MIT
