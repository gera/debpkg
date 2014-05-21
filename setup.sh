#!/bin/bash

SETUP_DISTS="wheezy"
CHROOT_BASE=/var/lib/schroot

if [ $UID -ne 0 ]; then
    echo "This requires root privs. Perhaps use sudo?" >&2
    exit 1
fi

echo "setting up build machine"
if [ ! -x /usr/sbin/debootstrap ]; then
    echo "installing debootstrap"
    apt-get install -y debootstrap
fi

if [ ! -x /usr/bin/schroot ]; then
    echo "installing schroot"
    apt-get install -y schroot
fi

for D in ${SETUP_DISTS}; do
    if [ ! -f "/etc/schroot/chroot.d/${D}-builds.conf" ]; then
        echo "making schroot entry for ${D}"
        echo -e "[${D}-builds]\ntype=directory\nmessage-verbosity=quiet\nroot-groups=users\npreserve-environment=true\ndirectory=${CHROOT_BASE}/${D}-builds\n" > "/etc/schroot/chroot.d/${D}-builds.conf"
    fi
done

for D in ${SETUP_DISTS}; do
    if [ ! -d "${CHROOT_BASE}/${D}-builds" ]; then
        echo "debootstrapping the ${D}-builds chroot"
        source /etc/default/proxy && debootstrap --variant=buildd --include=sudo,fakeroot,moreutils,openssh-client,apt-utils "${D}" "${CHROOT_BASE}/${D}-builds"
    fi
done

