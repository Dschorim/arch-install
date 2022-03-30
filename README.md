# arch-install
custom arch installation including btrfs and sway

## Requirements:
 - UEFI system
 - disks need to be partitioned (EFI Partition, maybe swap and root partition)
 - `git` needs to be installed with `pacman -Sy git`

## Notes:
 - even though the btrfs root partition uses multiple subvolumes, all of them are on a single partition