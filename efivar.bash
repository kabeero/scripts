#!/bin/sh -e

while ! [ -z "$1" ]; do
        case "$1" in
        "-f") filename="$2"; shift;;
        "-g") guid="$2"; shift;;
        *) name="$1";;
        esac
        shift
done

usage()
{
        echo "Syntax: ${0##*/} -f filename [ -g guid ] name"
        exit 1
}

[ -n "$name" -a -f "$filename" ] || usage

EFIVARFS="/sys/firmware/efi/efivars"

[ -d "$EFIVARFS" ] || exit 2

if stat -tf $EFIVARFS | grep -q -v de5e81e4; then
        mount -t efivarfs none $EFIVARFS
fi

# try to pick up an existing GUID
[ -n "$guid" ] || guid=$(find "$EFIVARFS" -name "$name-*" | head -n1 | cut -f2- -d-)

# use a randomly generated GUID
[ -n "$guid" ] || guid="$(cat /proc/sys/kernel/random/uuid)"

# efivarfs expects all of the data in one write
tmp=$(mktemp)
/bin/echo -ne "\007\000\000\000" | cat - $filename > $tmp
dd if=$tmp of="$EFIVARFS/$name-$guid" bs=$(stat -c %s $tmp)
rm $tmp
