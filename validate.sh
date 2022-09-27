#!/bin/bash

i=$1
echo Validation Run $i

# check link before
for if in enp1s0f0 enp1s0f1 enp1s0f2 enp1s0f3; do
    ifconfig $if up
    sleep 1
    ethtool $if | grep "Link detected" | grep yes >/dev/null || echo Warning: No Link before update
done
# show log-files
ls -lh *.log

# run update
./update.sh

# check link after
for if in enp1s0f0 enp1s0f1 enp1s0f2 enp1s0f3; do
    ifconfig $if up
    sleep 1
    ethtool $if | grep "Link detected" | grep yes >/dev/null || echo Warning: No Link after update
done

# save logs
mkdir -p validate
cp -v console.log validate/$i.console.log
cp -v updater.log validate/$i.updater.log

echo Validation Run $i Complete
