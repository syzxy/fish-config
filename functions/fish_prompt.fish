#-------------------- Helpers --------------------# 
function _nim_prompt_wrapper
    set -l retc $argv[1]
    set -l field_icon $argv[2]
    set -l field_value $argv[3]

    set_color normal
    set_color $retc
    echo -n ' | '
    test -n $field_icon
    and echo -n $field_icon
    echo -n ' ' $field_value
end

#-------------------- Fish Shell Hooks --------------------# 
function fish_prompt
    # This prompt shows:
    # - green lines if the last return command is OK, red otherwise
    # - your user name, in red if root or yellow otherwise
    # - your hostname, in cyan if ssh or blue otherwise
    # - the current path (with prompt_pwd)
    # - the current git status, if any, with fish_git_prompt

    # It goes from:
    # ╭─[nim@Hattori:~]
    # ╰─○ echo here

    # To:
    # ╭─[nim@Hattori:~/w/dashboard]─[master↑1|●1✚1…1]
    # │ 2    15054    0%    arrêtée    sleep 100000
    # │ 1    15048    0%    arrêtée    sleep 100000
    # ╰─○ echo there

    set -l retc red
    test $status = 0; and set retc green

    set_color $retc
    echo -n '╭─'

    # Current user
    if functions -q fish_is_root_user; and fish_is_root_user
        set_color red
    	echo -n ' '\uf0f0
    else
        set_color green
    	echo -n ' '\uf007
    end

    # Host name
    if test -z "$SSH_CLIENT"
    	_nim_prompt_wrapper blue \uf823
    else
    	_nim_prompt_wrapper cyan \uf98c (prompt_hostname)
    end

    # Git
    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto

    # Current directory
    set -l prompt_git (fish_git_prompt '%s')
    if test -n "$prompt_git"
    	_nim_prompt_wrapper f97551 \uf1d2 (prompt_pwd)
	_nim_prompt_wrapper f97551 $prompt_git
    else
    	_nim_prompt_wrapper blue \ue5ff (prompt_pwd)
    end

    # Second line
    echo
    set_color normal
    set_color $retc
    echo -n '╰─'\u25a2
    echo -n ' '
    set_color normal
end
