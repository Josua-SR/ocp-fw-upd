#!/bin/bash

if [ ! -e disk.img ]; then
    echo "Can't find prepared updater disk image (disk.img), aborting!"
    echo "Please create a bootable disk image by running make.sh first."
    exit 1
fi

# delete pre-existing log-file from disk image
mdel -v -i disk.img ::updater.log 2>/dev/null

# TODO: reset pci link

# unbind i40e driver
if [ -e /sys/bus/pci/drivers/i40e ]; then
    for i in $(seq 0 1 3); do
        if [ -e /sys/bus/pci/drivers/i40e/0000:01:00.$i ]; then
            echo 0000:01:00.$i > /sys/bus/pci/drivers/i40e/unbind
            if [ $? -ne 0 ]; then
                echo "Can't unbind 0000:01:00.$i from i40e driver, aborting!"
                exit 1
            fi
        fi
    done
fi

# load vfio-pci driver
if [ ! -e /sys/bus/pci/drivers/vfio-pci ]; then
    modprobe vfio-pci
    if [ ! -e /sys/bus/pci/drivers/vfio-pci ]; then
        echo "Can't load vfio-pci driver, aborting!"
        exit 1
    fi
fi

# enable workaround for broken d3
echo Y > /sys/module/vfio_pci/parameters/disable_idle_d3

# bind to vfio-pci driver
echo 8086 1572 > /sys/bus/pci/drivers/vfio-pci/new_id
for i in $(seq 0 1 3); do
    if [ ! -e /sys/bus/pci/drivers/vfio-pci/0000:01:00.$i ]; then
        echo 0000:01:00.$i > /sys/bus/pci/drivers/vfio-pci/bind
        if [ $? -ne 0 ]; then
            echo "Can't bind 0000:01:00.$i to vfio-pci driver, aborting!"
            exit 1
        fi
    fi
done

# start emulator
qemu-system-x86_64 \
    -no-reboot \
    -nographic \
    -nic none \
    -vga none \
    -chardev stdio,id=char0,logfile=console.log,signal=off,mux=on \
    -serial chardev:char0 \
    -mon chardev=char0 \
    -bios /usr/share/ovmf/OVMF.fd \
    -drive file=disk.img,format=raw,media=disk \
    -device pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pci.0,multifunction=on,addr=0x2 \
    -device vfio-pci,host=01:00.0,bus=pci.1,addr=0 \
    -device vfio-pci,host=01:00.1,bus=pci.1,addr=1 \
    -device vfio-pci,host=01:00.2,bus=pci.1,addr=2 \
    -device vfio-pci,host=01:00.3,bus=pci.1,addr=3 \
    -boot order=c \

    :

if [ $? -ne 0 ]; then
    echo "Warning: System Emulator exited with non-zero return code. Carefully review logs for errors!"
fi

# extract log-file from disk image
mcopy -v -i disk.img ::updater.log updater.log

# reconnect ocp card by issuing remove and rescan
echo "Resetting PCI link ..."
if [ -e /sys/bus/pci/devices/0000:00:00.0 ]; then
    echo 1 > /sys/bus/pci/devices/0000:00:00.0/remove
    sleep 1
fi
echo 1 > /sys/bus/pci/rescan

echo "Done."
exit $s
