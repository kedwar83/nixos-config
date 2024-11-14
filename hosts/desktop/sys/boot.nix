{
  config,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "/dev/nvme0n1";
      grub.useOSProber = true;
      grub.enableCryptodisk = true;
    };
    initrd = {
      luks.devices = {
        "luks-e8a21db0-9d33-4155-b12e-d4aeb57b9bd0" = {
          device = "/dev/disk/by-uuid/e8a21db0-9d33-4155-b12e-d4aeb57b9bd0";
          keyFile = "/boot/crypto_keyfile.bin";
        };
        "luks-a0b27b0a-f8ac-4904-a1ad-b6aef0a82435" = {
          device = "/dev/disk/by-uuid/a0b27b0a-f8ac-4904-a1ad-b6aef0a82435";
          keyFile = "/boot/crypto_keyfile.bin";
        };
      };
      secrets = {
        "/boot/crypto_keyfile.bin" = null;
      };
    };
  };
}
