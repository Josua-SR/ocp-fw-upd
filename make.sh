#!/bin/bash
#
# Copyright Josua Mayer <josua@solid-run.com>
#

# ensure pipes propagate error status codes
set -o pipefail

# check for some files
if [ ! -e startup.nsh ]; then
    echo "Can't find autostart script (startup.nsh), aborting!"
    exit 1
fi

if [ ! -d 700Series/EFI2x64 ] || [ ! -f 700Series/EFI2x64/nvmupdate64e.efi ]; then
    echo "Can't find firmware update utility, aborting!"
    echo "Please download and unpack the firmware updater from Intel, to create 700Series/EFI2x64."
    exit 1
fi

# generate updater disk image
s=0
rm -f disk.img || s=$?
dd if=/dev/zero of=disk.img bs=1M seek=1000 count=1 || s=$?
mformat -F -i disk.img :: || s=$?
mcopy -i disk.img startup.nsh :: || s=$?
find 700Series/EFI2x64 -type f | xargs -I '{}' mcopy -v -i disk.img {} :: || s=$?

if [ $s -eq 0 ]; then
    echo "Done."
else
    echo "Failed ...!"
fi
exit $s
