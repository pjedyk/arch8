#! /bin/bash --
# vim: set et ts=2 sts=2 sw=2 :

T="/$0" T="${T%/*}" T="${T#/}" T="${T:-.}" T="$( cd -- "$T" && pwd )" &&
source -- "$T/../lib.sh" || exit

do_patch /etc/sudoers "$T/patch/sudoers"
