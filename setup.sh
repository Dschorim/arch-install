#!/bin/bash

if [ ! -d "/sys/firmware/efi/efivars" ]; then
  echo "System not booted in UEFI mode"
  exit 1
fi

echo "Please enter the EFI partition name (e.g. /dev/sda1):"
read EFI_PARTITION

re = '^[0-9]+$'
if [ "$EFI_PARTITION" = "" ]; then
    EFI_PARTITION="/dev/sda1"
elif [[ $EFI_PARTITION =~ $re]]; then
    EFI_PARTITION="/dev/sda$EFI_PARTITION"
fi

echo "Do you want to format the EFI partition? (Y/n)"
read FORMAT_EFI

if [ "$FORMAT_EFI" = "n" ]; then
    echo "Skipping EFI partition formatting..."
else
    echo "Formatting EFI partition $EFI_PARTITION..."
    mkfs.fat -F32 $EFI_PARTITION
fi

echo "Please enter the swap partition name (e.g. /dev/sda2). Leave blank for none:"
read SWAP_PARTITION

if [ "$SWAP_PARTITION" =~ "^[0-9]+$"]; then
    SWAP_PARTITION="/dev/sda$SWAP_PARTITION"
fi

if [ "$SWAP_PARTITION" != "" ]; then
    mkswap $SWAP_PARTITION
    swapon $SWAP_PARTITION
else 
    echo "Skipping swap creation..."
fi

echo "Please enter the root partition name (e.g. /dev/sda3):"
read ROOT_PARTITION

if [ "$ROOT_PARTITION" = "" ]; then
    ROOT_PARTITION="/dev/sda3"
elif [ "$ROOT_PARTITION" =~ "^[0-9]+$"]; then
    ROOT_PARTITION="/dev/sda$ROOT_PARTITION"
fi

if [ "$ROOT_PARTITION" != "" ]; then
    echo "Formatting root partition..."
    mkfs.btrfs -f $ROOT_PARTITION
else
    echo "No root partition specified. Exiting..."
    exit 1
fi

echo "Creating btrfs subvolumes..."
mount $ROOT_PARTITION /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@.snapshots
umount /mnt

echo "Mounting subvolumes..."
mount -o noatime,commit=120,compress=zstd,space_cache=v2,subvol=@ $ROOT_PARTITION /mnt
mkdir /mnt/{boot,home,var,opt,tmp,.snapshots}
mount -o noatime,commit=120,compress=zstd,space_cache=v2,subvol=@home $ROOT_PARTITION /mnt/home
mount -o noatime,commit=120,compress=zstd,space_cache=v2,subvol=@opt $ROOT_PARTITION /mnt/opt
mount -o noatime,commit=120,compress=zstd,space_cache=v2,subvol=@tmp $ROOT_PARTITION /mnt/tmp
mount -o noatime,commit=120,compress=zstd,space_cache=v2,subvol=@.snapshots $ROOT_PARTITION /mnt/.snapshots
mount -o subvol=@var $ROOT_PARTITION /mnt/var
mount $EFI_PARTITION /mnt/boot

echo "Which CPU are you using? (intel/AMD/VM)"
read CPU_TYPE
echo "Installing base system..."
if [ "$CPU_TYPE" = "intel" ]; then
    pacstrap /mnt base linux linux-firmware nano intel-ucode btrfs-progs
elif [ "$CPU_TYPE" = "AMD" ]; then
    pacstrap /mnt base linux linux-firmware nano amd-ucode btrfs-progs
elif [ "$CPU_TYPE" = "VM" ]; then
    pacstrap /mnt base linux linux-firmware nano btrfs-progs
else
    echo "Invalid CPU type. Exiting..."
    exit 1
fi

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Please enter the chroot with 'arch-chroot /mnt' and execute the 'chroot.sh' script."

arch-root /mnt /bin/bash -c "./chroot.sh"