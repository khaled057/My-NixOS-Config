{ config, lib, ... }:

{
  # Point nixos-facter at your hardware report
  facter.reportPath = ./facter.json;

  barelyMetal = {
    enable = true;

    # Pass your hardware probe data
    probeData = builtins.fromJSON (builtins.readFile ./probe.json);

    # Users to add to kvm, libvirtd, input groups
    users = [ "khaled" ];

    # Replace the OVMF boot logo (saved by barely-metal-probe)
    spoofing.bootLogo = ./boot-logo.bmp;

    vm = {
      memory = 12288;       # MiB
      cores = 4;
      threads = 2;
      audioBackend = "pipewire";

      # Laptop spoofing (fake ACPI battery + embedded controller/fan/power button)
       useFakeBattery = true;
       useSpoofedDevices = true;

      # Windows ISO for initial install
       isoPath = /home/khaled/Downloads/win10.iso;

      # evdev input passthrough
       evdevInputs = [
         "/dev/input/by-id/usb-Lenovo_Lenovo_Gaming_Mouse-event-mouse"
         "/dev/input/by-id/usb-SINO_WEALTH_Gaming_KB-event-kbd"
       ];

      # Hyper-V passthrough mode (some anti-cheats prefer this over hidden KVM)
      # enableHyperVPassthrough = true;
    };

    # GPU passthrough (optional)
     vfio = {
       enable = true;
       pciIds = [ 
        "10de:25ed"
        "10de:2291"
 ];
     };

    # Looking Glass shared memory display (optional)
     lookingGlass = {
       enable = true;
       user = "khaled";
       shmSize = 64;
     };
  };
}
