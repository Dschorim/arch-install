#!/bin/bash

if [ ! -d "/sys/firmware/efi/efivars" ]; then
  echo "System not booted in UEFI mode"
  exit 1
fi

read -r -p "Please enter the EFI partition name (e.g. /dev/sda1): " EFI_PARTITION

re='^[0-9]+$'
if [ "$EFI_PARTITION" = "" ]; then
    EFI_PARTITION="/dev/sda1"
elif [[ $EFI_PARTITION =~ $re ]]; then
    EFI_PARTITION="/dev/sda$EFI_PARTITION"
fi

read -r -p "Do you want to format the EFI partition? (Y/n): " FORMAT_EFI

if [ "$FORMAT_EFI" = "n" ]; then
    echo "Skipping EFI partition formatting..."
else
    echo "Formatting EFI partition $EFI_PARTITION..."
    mkfs.fat -F32 $EFI_PARTITION
fi

read -r -p "Please enter the swap partition name (e.g. /dev/sda2). Leave blank for none: " SWAP_PARTITION

if [[ $SWAP_PARTITION =~ $re ]]; then
    SWAP_PARTITION="/dev/sda$SWAP_PARTITION"
fi

if [ "$SWAP_PARTITION" != "" ]; then
    mkswap "$SWAP_PARTITION"
    swapon "$SWAP_PARTITION"
else 
    echo "Skipping swap creation..."
fi

read -r -p "Please enter the root partition name (e.g. /dev/sda3): " ROOT_PARTITION

if [ "$ROOT_PARTITION" = "" ]; then
    ROOT_PARTITION="/dev/sda3"
elif [[ $ROOT_PARTITION =~ $re ]]; then
    ROOT_PARTITION="/dev/sda$ROOT_PARTITION"
fi

if [ "$ROOT_PARTITION" != "" ]; then
    echo "Formatting root partition..."
    cryptsetup luksFormat "$ROOT_PARTITION"
    cryptsetup open "$ROOT_PARTITION" cryptroot
    mkfs.btrfs -f /dev/mapper/cryptroot
else
    echo "No root partition specified. Exiting..."
    exit 1
fi

echo "Creating btrfs subvolumes..."
mount /dev/mapper/cryptroot /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@.snapshots
umount /mnt

echo "Mounting subvolumes..."
mount -o noatime,commit=120,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt
mkdir /mnt/{boot,home,var,opt,tmp,.snapshots}
mount -o noatime,commit=120,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,commit=120,compress=zstd,space_cache=v2,discard=async,subvol=@opt /dev/mapper/cryptroot /mnt/opt
mount -o noatime,commit=120,compress=zstd,space_cache=v2,discard=async,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
mount -o noatime,commit=120,compress=zstd,space_cache=v2,discard=async,subvol=@.snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o subvol=@var /dev/mapper/cryptroot /mnt/var
mount /dev/mapper/cryptroot /mnt/boot

read -r -p "Which CPU are you using? (intel/AMD/VM) " CPU_TYPE
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

arch-chroot /mnt /bin/bash -c "pacman -Sy git && git clone https://github.com/Dschorim/arch-install.git && cd arch-install && bash chroot.sh $ROOT_PARTITION && exit"

rm -rf /mnt/arch-install
