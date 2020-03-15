# arch8

My private Arch Linux installation helper & configurer.

## Usage

### QEMU

```sh
./image.bin.create
./image.bin.mount
./10-fetch
# Uncomment servers
./11-mpopul
./12-mount
./13-copy
./14-fstab
# Remove unnecessary entries
./19-chroot
```

```sh
# In chroot
./arch8/20-grow
./arch8/21-user
# Set root password
./arch8/22-newuser
# Enter name, fullname
# Set new user password
./arch8/21-user
./arch8/30-initrd-full
# Probably enter user password (for sudo)
./arch8/31-boot-grub-efi-removable
# Ctrl+D
# Ctrl+D
```

```sh
# NOT in chroot
./49-umount
./image.bin.umount
./image.qcow2.create
./image.qcow2.start
```

```sh
# In QEMU:
# Log in as user
./arch8/50-system
./arch8/51-user
reboot
```

### Computer

Assume `/dev/sdX` as installation device (e.g., USB flash drive).

#### Prepare installation device (instead `image.bin.create`)

```sh
printf '%s\n' g n '' '' +300M t 1 n '' '' '' w \
| fdisk /dev/sdX
mkfs.vfat -nESP -F32 /dev/sdX1
mkfs.btrfs -f -Linstall /dev/sdX2
```

#### Mount installation device (instead `image.bin.mount`)

```sh
mkdir m
mount -onoatime,nodiratime /dev/sdX2 m
mkdir -p m/esp m/boot
mount -onoatime,nodiratime /dev/sdX1 m/esp
mkdir -p m/esp/EFI/install
mount -obind m/esp/EFI/install m/boot
```

#### Install temporary system

```sh
./10-fetch
# Uncomment servers
./11-mpopul
./12-mount
./13-copy
./13-copy-offline
./14-fstab
# Remove unnecessary entries
./19-chroot
```

```sh
# In chroot
./arch8/20-grow
./arch8/21-user
# Set root password
./arch8/30-initrd-full
# Probably enter user password (for sudo)
./arch8/31-boot-grub-efi-removable
# Ctrl+D
# Ctrl+D
```

```sh
# NOT in chroot
./49-umount
```

#### Unmount installation device (instead `image.bin.umount`)

```sh
umount m/boot m/esp m
rmdir m
```

#### Install on target

Assume `/dev/sdY` as target device (e.g., hard drive).

```sh
# Boot just prepared installation device
# Log in as root
printf '%s\n' g n '' '' +300M t 1 n '' '' +1G t '' 19 n '' '' '' w \
| fdisk /dev/sdY
mkfs.vfat -nESP -F32 /dev/sdY1
mkswap -Lswap /dev/sdY2
mkfs.btrfs -f -Ltarget /dev/sdY3
mkdir m
mount -onoatime,nodiratime /dev/sdY3 m
mkdir -p m/esp m/boot
mount -onoatime,nodiratime /dev/sdY1 m/esp
mkdir -p m/esp/EFI/target
mount -obind m/esp/EFI/target m/boot
swapon /dev/sdY2
./11-mpopul
./12-mount
./13-copy
./13-copy-target
./14-fstab
# Remove unnecessary entries
./19-chroot
```

```sh
# In chroot
./arch8/20-grow
./arch8/21-user
# Set root password
./arch8/22-newuser
# Enter name, fullname
# Set new user password
./arch8/21-user
./arch8/30-initrd
# Probably enter user password (for sudo)
./arch8/31-boot-grub-efi
# Ctrl+D
# Ctrl+D
```

```sh
# NOT in chroot
./49-umount
umount m/boot m/esp m
swapoff /dev/sdY2
rmdir m
```

#### Configure target

```sh
# Boot just installed target
# Log in as user
./arch8/50-system
./arch8/51-user
reboot
```

## Remarks

Happy formatting!
