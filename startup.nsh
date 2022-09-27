#
# Copyright Josua Mayer <josua@solid-run.com>
#
@echo -off

echo Welcome to SolidRun OCP-Card Firmware Update Script

if exist .\nvmupdate64e.efi then
    goto RUNUPD
endif
if exist fs0:\nvmupdate64e.efi then
    fs0:
    goto RUNUPD
endif
echo Failed to find nvmupdate64e.efi on fs0, aborting!
goto EXIT

:RUNUPD
echo Starting Intel Firmware Updater
nvmupdate64e.efi -l updater.log -u
if not %lasterror% == 0 then
  echo Intel Firmware Updater returned %lasterror%!
  goto EXIT
endif
echo Intel Firmware Updater complete.

:EXIT
# Shutdown machine
echo SolidRun OCP-Card Firmware Update Script Finished, Shutting down Machine ...
reset -s completed
