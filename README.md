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

```sh
dev=/dev/sdX
```

#### Prepare installation device (instead `image.bin.create`)

```sh
printf '%s\n' g n '' '' +300M t 1 n '' '' '' w | fdisk ${dev}
mkfs.vfat -nESP -F32 ${dev}1
mkfs.btrfs -f -Linstall ${dev}2
```

#### Mount installation device (instead `image.bin.mount`)

```sh
mkdir m
mount -onoatime,nodiratime ${dev}2 m
mkdir -p m/esp m/boot
mount -onoatime,nodiratime ${dev}1 m/esp
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
./arch8/31-boot-grub-efi-removable
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
target_dev=/dev/sdY
```

#### Prepare target device

```sh
# Boot just prepared installation device
# Log in as root
printf '%s\n' g n '' '' +300M t 1 n '' '' +1G t '' 19 n '' '' '' w | fdisk ${target_dev}
mkfs.vfat -nESP -F32 ${target_dev}1
mkswap -Lswap ${target_dev}2
mkfs.btrfs -f -Ltarget ${target_dev}3
mkdir m
mount -onoatime,nodiratime ${target_dev}3 m
mkdir -p m/esp m/boot
mount -onoatime,nodiratime ${target_dev}1 m/esp
mkdir -p m/esp/EFI/target
mount -obind m/esp/EFI/target m/boot
swapon ${target_dev}2
```

#### Install system

```sh
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
swapoff ${target_dev}2
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

## Scripts safety table

- *Safe* -- Does not modify files outside this directory and subdirectories.
- *In chroot* -- Modifies system and/or user files. Use in chroot and on
  target OS.
- *NOT SAFE* -- Modifies system and/or user files and/or others (e.g.,
  `efivarfs`). Use **only** on target OS!

| Script                     | Safety       |
|----------------------------|--------------|
| 00-dummy                   | Safe         |
| 10-fetch                   | Safe         |
| 11-mpopul                  | Safe         |
| 12-mount                   | Safe         |
| 13-copy                    | Safe         |
| 13-copy-offline            | Safe         |
| 13-copy-target             | Safe         |
| 14-fstab                   | Safe         |
| 19-chroot                  | Safe         |
| 20-grow                    | In chroot    |
| 20-grow-local              | In chroot    |
| 21-user                    | In chroot    |
| 22-newuser                 | In chroot    |
| 30-initrd                  | In chroot    |
| 30-initrd-full             | In chroot    |
| 31-boot-grub-efi           | **NOT SAFE** |
| 31-boot-grub-efi-removable | In chroot    |
| 49-umount                  | Safe         |
| 50-system                  | **NOT SAFE** |
| 51-user                    | **NOT SAFE** |
| 99-clean                   | Safe         |

## Remarks

Happy formatting!
