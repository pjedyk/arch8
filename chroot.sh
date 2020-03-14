#! /bin/false --

export -- HOME=/root USER=root PATH=/bin IN_CHROOT=X &&
T="/$0" T="${T%/*}" T="${T#/}" T="${T:-.}" T="$( cd -- "$T" && pwd )" &&
source -- "$T/lib.sh" || exit

cd

if [[ "$#" -gt 0 ]] ; then
  exec -- "$@"

else
  exec /bin/bash

fi
