#! /bin/false --

set -eu -o pipefail
shopt -s nullglob

sudo= ; [[ $UID -eq 0 ]] || sudo='sudo --'
edit='vim --' ; [[ -z "${EDITOR-}" ]] || edit="$EDITOR"

do_backup_remove_su() {
  if [[ -e "$1.pacnew" ]] ; then
    $sudo rm -fr -- "$1~" &&
    $sudo mv -fT -- "$1.pacnew" "$1~" &&
    : || return

  fi

  if [[ ! -e "$1~" ]] ; then
    if [[ ! -e "$1" ]] ; then
      $sudo touch -- "$1~"

    else
      $sudo mv -fT -- "$1" "$1~"

    fi

  else
    $sudo rm -fr -- "$1"

  fi
}

do_restore_su() {
  do_backup_remove_su "$1" &&
  $sudo cp -afT -- "$1~" "$1"

}

do_patch_su() {
  do_restore_su "$1" &&
  $sudo patch -d/ -fl -p0 --posix <"$2" &&
  $sudo rm -f -- "$1.orig"

}

do_link_su() {
  do_backup_remove_su "$1" &&
  $sudo ln -fnrsT -- "$2" "$1"
}

do_backup_remove() {
  local sudo= &&
  do_backup_remove_su "$@"

}

do_restore() {
  local sudo= &&
  do_restore_su "$@"

}

do_patch() {
  local sudo= &&
  do_patch_su "$@"

}

do_link() {
  local sudo= &&
  do_link_su "$@"

}

do_chroot() {
  local env="$( which env )" &&
  local chroot="$( which chroot )" &&

  ( exec -c -- \
        "$env" -- TERM="$TERM" \
        $sudo "$chroot" -- "$T/m" \
        /bin/bash -- "/root/${T##*/}/chroot.sh" "$@" \
  )

}
