_bold=$(tput bold)
_normal=$(tput sgr0)

__prompt_command() {
  local vcs base_dir sub_dir ref last_command
  sub_dir() {
    local sub_dir
    sub_dir=$(stat -f "${PWD}")
    sub_dir=${sub_dir#$1}
    echo ${sub_dir#/}
  }

  git_dir() {
    base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir=$(git rev-parse --show-prefix)
    sub_dir="/${sub_dir%/}"

    local br
    if test -f "$base_dir/.git/HEAD" ; then
      read br < "$base_dir/.git/HEAD"
      case $br in
        ref:\ refs/heads/*) br=${br#ref: refs/heads/} ;;
        *) br=$(echo "$br" | cut -c 1-7) ;;
      esac
      if [ -f "$base_dir/.git/rebase-merge/interactive" ]; then
        b="$(cat "$base_dir/.git/rebase-merge/head-name")"
        b=${b#refs/heads/}
        br="$br|REBASE-i|$b"
      elif [ -d "$base_dir/.git/rebase-merge" ]; then
        b="$(cat "$base_dir/.git/rebase-merge/head-name")"
        b=${b#refs/heads/}
        br="$br|REBASE-m|$b"
      else
        if [ -d "$base_dir/.git/rebase-apply" ]; then
          if [ -f "$base_dir/.git/rebase-apply/rebasing" ]; then
            b="$(cat "$base_dir/.git/rebase-apply/head-name")"
            b=${b#refs/heads/}
            br="$br|REBASE|$b"
          elif [ -f "$base_dir/.git/rebase-apply/applying" ]; then
            br="$br|AM"
          else
            br="$br|AM/REBASE"
          fi
        elif [ -f "$base_dir/.git/CHERRY_PICK_HEAD" ]; then
          br="$br|CHERRY-PICKING"
        elif [ -f "$base_dir/.git/REVERT_HEAD" ]; then
          br="$br|REVERTING"
        elif [ -f "$base_dir/.git/MERGE_HEAD" ]; then
          br="$br|MERGE"
        elif [ -f "$base_dir/.git/BISECT_LOG" ]; then
          br="$br|BISECT"
        fi
      fi
    fi

    ref="$br"
    vcs="git"
  }

  hg_dir() {
    base_dir=$PWD
    while : ; do
      if test -d "$base_dir/.hg" ; then
        vcs="hg"
        break
      fi
      test "$base_dir" = / && break
      # portable "realpath" equivalent
      base_dir=$(cd -P "$base_dir/.." && echo "$PWD")
    done

    [ "$vcs" = "hg" ] || return 1

    local br extra
    if [ -f "$base_dir/.hg/bisect.state" ]; then
      extra="|BISECT"
    elif [ -f "$base_dir/.hg/histedit-state" ]; then
      extra="|HISTEDIT"
    elif [ -f "$base_dir/.hg/graftstate" ]; then
      extra="|GRAFT"
    elif [ -f "$base_dir/.hg/unshelverebasestate" ]; then
      extra="|UNSHELVE"
    elif [ -f "$base_dir/.hg/rebasestate" ]; then
      extra="|REBASE"
    elif [ -d "$base_dir/.hg/merge" ]; then
      extra="|MERGE"
    fi
    local dirstate=$(test -f "$base_dir/.hg/dirstate" && \
      hexdump -vn 20 -e '1/1 "%02x"' "$base_dir/.hg/dirstate" || \
      echo "empty")
    local current="$base_dir/.hg/bookmarks.current"
    if  [[ -f "$current" ]]; then
      br=$(cat "$current")
      # check to see if active bookmark needs update (eg, moved after pull)
      local marks="$base_dir/.hg/bookmarks"
      if [[ -f "$base_dir/.hg/sharedpath"  && -f "$base_dir/.hg/shared" ]] &&
          grep -q '^bookmarks$' "$base_dir/.hg/shared"; then
        marks="$(cat $base_dir/.hg/sharedpath)/bookmarks"
      fi
      if [[ -z "$extra" ]] && [[ -f "$marks" ]]; then
        local markstate=$(grep --color=never " $br$" "$marks" | cut -f 1 -d ' ')
        if [[ $markstate != "$dirstate" ]]; then
          extra="|UPDATE_NEEDED"
        fi
      fi
    else
      br=$(echo "$dirstate" | cut -c 1-7)
    fi
    local remote="$base_dir/.hg/remotenames"
    if [[ -f "$remote" ]]; then
      local marks=$(grep --color=never "^$dirstate bookmarks" "$remote" | \
        cut -f 3 -d ' ' | tr '\n' '|' | sed -e 's/|$//')
      if [[ -n "$marks" ]]; then
        br="$br|$marks"
      fi
    fi
    local branch
    if [[ -f "$base_dir/.hg/branch" ]]; then
      branch=$(cat "$base_dir/.hg/branch")
      if [[ $branch != "default" ]]; then
        br="$br|$branch"
      fi
    fi
    br="$br$extra"

    ref="$br"
    sub_dir="/$(sub_dir "${base_dir}")"
  }

  svn_dir() {
    [ -d ".svn" ] || return 1
    base_dir="."
    while [ -d "$base_dir/../.svn" ]; do base_dir="$base_dir/.."; done
    base_dir=`cd $base_dir; pwd`
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=$(svn info "$base_dir" | awk '/^URL/ { sub(".*/","",$0); r=$0 } /^Revision/ { sub("[^0-9]*","",$0); print r":"$0 }')
    vcs="svn"
  }

  bzr_dir() {
    base_dir=$(bzr root 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=$(bzr revno 2>/dev/null)
    vcs="bzr"
  }

  git_dir || hg_dir || svn_dir || bzr_dir

  if [ -n "$vcs" ]; then
    base_dir="$(basename "${base_dir}")"
    working_on="$base_dir:"
    __vcs_prefix="($vcs)"
    __vcs_ref="[$ref]"
    __vcs_sub_dir="${sub_dir}"
    __vcs_base_dir="${base_dir/$HOME/~}"
  else
    __vcs_prefix=''
    __vcs_base_dir="${PWD/$HOME/~}"
    __vcs_ref=''
    __vcs_sub_dir=''
    working_on=""
  fi

  last_command=$(history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")
  __tab_title="$working_on[$last_command]"
  __pretty_pwd="${PWD/$HOME/~}"
}

PROMPT_COMMAND=__prompt_command
PS1='\[\033[G\]\[\e]2;\h::$__pretty_pwd\a\e]1;$__tab_title\a\]\u:$__vcs_prefix\[${_bold}\]${__vcs_base_dir}\[${_normal}\]${__vcs_ref}\[${_bold}\]${__vcs_sub_dir}\[${_normal}\]\$ '

_complete_ssh_hosts ()
{
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    comp_ssh_hosts=`cat ~/.ssh/known_hosts |
        cut -f 1 -d ' ' |
        sed -e s/,.*//g |
        grep -v ^# |
        uniq |
        grep -v "\[" ;
        cat ~/.ssh/config |
        grep "^Host " |
        awk '{print $2}'
        `
    COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
    return 0
}
complete -F _complete_ssh_hosts c9ssh

# Show the currently running command in the terminal title:
# http://www.davidpashley.com/articles/xterm-titles-with-bash.html
#if [ -z "$TM_SUPPORT_PATH"]; then
#case $TERM in
#  rxvt|*term|xterm-color)
#    trap 'echo -e "\e]1;$working_on>$BASH_COMMAND<\007\c"' DEBUG
#  ;;
#esac
#fi
