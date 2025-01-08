# Example to create a bios compatible gpt partition
{ ... }: {
  disko.devices = {
    disk.disk1 = {
      # volume labels can switch around during reboot and
      # cause the system to try to boot from the wrong disk.
      # For this reason, we will use /dev/disk/by-id.
      # By running the following commands,
      # we can determine the devices we need:
      # https://joinemm.dev/blog/nixos-hetzner-cloud#disks
      #
      # $ lsblk
      # $ ls -la /dev/disk/by-id
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_56766495";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}
