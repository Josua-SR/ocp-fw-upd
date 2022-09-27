# Intel OCP Card Firmware Update

Instructions for running [Intel's Firmware Update Utility for 700 series PCI-E NICs](https://www.intel.com/content/www/us/en/download/18190/non-volatile-memory-nvm-update-utility-for-intel-ethernet-network-adapter-700-series.html) on arm64, using QEMU and PCI-e passthrough.

## Download Latest Updater from Intel

Navigate to the [Intel NVM Update Utility for ntel Ethernet Network Adapter 700 Sries Download Page](https://www.intel.com/content/www/us/en/download/18190/non-volatile-memory-nvm-update-utility-for-intel-ethernet-network-adapter-700-series.html) and download `700Series_NVMUpdatePackage_v9_01.zip` or later.
From this archive extract the contents of nested `700Series_NVMUpdatePackage_v9_01_EFI.zip` to this directory (containing `startup.nsh`).
There shall now be a folder `700Series/EFI2x64` containing latest firmware binaries, and in particular the update application `nvmupdate64e.efi`.

## Create bootable disk image from Updater

First install required utilities:

apt-get install findutils mtools

Then on a command prompt change directory to this directory (containing `startup.nsh`), then execute `make.sh` and wait:

    ./make.sh

## Install System Emulator

Install both the qemu x86 system emulator, the ovmf uefi firmware and utilities:

    apt-get install mtools ovmf qemu-system-x86

## Execute Update

First ensure that any applications accessing the OCP Card have stopped, and that a separate network connection is available for retrieving logs.
If Linux is currently using the i40e interface driver, the script will automatically unbind it for the duration of the update procedure!

On a command prompt change directory to this directory (containing `startup.nsh`), then execute `update.sh` and wait:

    ./update.sh

This process can take 10 minutes to execute with very minimal messages. After the script is done, make sure to review some log files:

- console.log
- updater.log

## See Also

- [Intel NVM Update Utility for Intel Ethernet Network Adapter 700 Series Download Page](https://www.intel.com/content/www/us/en/download/18190/non-volatile-memory-nvm-update-utility-for-intel-ethernet-network-adapter-700-series.html)
- [Documentation for UEFI Intel NVM Update Utility](https://www-ssl.intel.com/content/www/us/en/embedded/products/networking/nvm-update-tool-quick-linux-usage-guide.html)
