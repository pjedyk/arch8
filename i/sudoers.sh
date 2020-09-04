#! /bin/bash --

T="/$0" T="${T%/*}" T="${T#/}" T="${T:-.}" T="$( cd -- "$T" && pwd )" &&
source -- "$T/../lib.sh" || exit

do_patch /etc/sudoers "$T/patch/sudoers"
