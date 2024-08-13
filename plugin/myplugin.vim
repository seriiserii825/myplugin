
" Define a command to trigger your plugin's functionality
command! OpenGitProject call OpenGitProjectInBrowser()
command! OpenGitProjectFile call OpenGitProjectInBrowser(1)

function! OpenGitProjectInBrowser(mode = 0)
  " Get the current Git root directory
  let l:git_root = system('git rev-parse --show-toplevel')
  if v:shell_error
    echo "Not a git repository"
    return
  endif

  " Remove any trailing newline
  let l:git_root = substitute(l:git_root, '\n', '', '')

  " Extract the GitHub/Bitbucket/other remote URL from the Git config
  let l:remote_url = system('git config --get remote.origin.url')
  if v:shell_error
    echo "Could not find remote repository"
    return
  endif

  function! ConvertSshToHttps(ssh_url, current_file)
    " Remove 'git@' from the SSH URL and convert to HTTPS format
    echo a:ssh_url
    " Replace the second occurrence of ':' with '/'
    let l:url = substitute(a:ssh_url, ':', '/', '')
    echo 'URL after colon substitution: ' . l:url
    let l:url = substitute(l:url, '\n', '', '')

    " Print the URL after replacing the second ':'
    echo 'URL after colon substitution: ' . l:url
    " Get the last 5 characters (or fewer if the line is shorter)
    let l:end_symbols = l:url[-5:]

    " Print the characters at the end of the line
    echo 'End of line symbols: "' . l:end_symbols . '"'

    let l:url = substitute(l:url, '^git@', 'https://', '')

    " Print the URL after the first substitution
    echo 'URL after git@ substitution: ' . l:url

    " Explicitly check and remove the '.git' suffix
    let git_sign = '\.git$'
    if l:url =~ git_sign
      echo 'URL contains .git suffix'
      let l:no_git = substitute(l:url, git_sign, '', '')
      echo 'URL after removing .git: ' . l:no_git
    else
      echo 'URL does not contain .git suffix'
      let l:no_git = l:url
      echo 'URL after removing .git: ' . l:no_git
    endif

    " if url contains bitbucket
    if l:no_git =~ 'bitbucket'
      echo 'URL contains Bitbucket'
      if a:mode == 1
        let l:https_url = l:no_git . '/src/main' . a:current_file
        return l:https_url
      else
        let l:https_url = l:no_git . '/src/main'
        return l:https_url
      endif
    else
      if a:mode == 1
        return l:no_git . '/blob/main' . a:current_file
      else
        return l:no_git . '/blob/main'
      endif
    endif
  endfunction

  "get current file in project
  let l:current_file = expand('%:p')
  let l:current_file = substitute(l:current_file, l:git_root, '', '')

  let ssh_url = l:remote_url
  let https_url = ConvertSshToHttps(ssh_url, current_file)
  echo https_url

  " Open the remote URL in the default web browser
  if has('mac')
    let l:open_cmd = 'open ' . https_url
  elseif has('unix')
    let l:open_cmd = 'google-chrome-stable ' . https_url
  elseif has('win32')
    let l:open_cmd = 'start ' . https_url
  else
    echo "Unsupported OS"
    return
  endif
  echo "Opening " . l:open_cmd . " in the browser"

  call system(l:open_cmd)
endfunction

nmap <leader>gp :OpenGitProject<CR><CR>
nmap <leader>gf :OpenGitProject<CR><CR>
