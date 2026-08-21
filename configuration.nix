{ config, lib, pkgs, inputs, ... }:
{
imports =
    [ 
      ./hardware-configuration.nix
      ./graphical.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Optimizing the store with every build
  nix.settings.auto-optimise-store = true;
  # Limiting nix build jobs to avoid out of memory situations
  nix.settings = {
    cores = 4;
    max-jobs = 2;
}; 
  # Garbage Collection of old generations
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
  # A problem with building python 3.12, a workaround is found
  documentation.doc.enable = false;
  # Boot loader and some stuff.
   boot = {
   #kernelParams = [ "quiet" ];
   # By default, the latest LTS linux kernel is installed 
   #kernelPackages = pkgs.linuxPackages_latest; # The linux kernel to boot with
   # Enable SysRq shortcuts can be used to trigger a more graceful reboot
   kernel.sysctl."kernel.sysrq" = 1;
   supportedFilesystems = [ "nfs" ]; # to have NFS support
   loader = {
   #efi.canTouchEfiVariables = true;
   timeout = 1;
   grub = {
    enable = true;
    useOSProber = false;
    efiSupport = true;
    splashImage = ./photo.jpg;
    efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
    devices = ["nodev"];
    extraEntriesBeforeNixOS = false;
    extraEntries = ''
      menuentry "Reboot" {
        reboot
      }
      menuentry "Poweroff" {
        halt
      }
    '';
  };
};};
  networking.hostName = "nixos"; # Define your hostname.
  # Enable Networking 
  networking.networkmanager.enable = true;

  # Set your time zone.
   time.timeZone = "Africa/Cairo";

 # Doas instead of Sudo
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
    users = ["khaled"];
    keepEnv = true;
    persist = true;
  }];
  };

  users.users.khaled = {
    isNormalUser = true;
    description = "Khaled M. Hosny";
    extraGroups = [ "networkmanager" "libvirtd" "kvm" "ydotool" "video" "render" "samba" "podman" ];
 };
   environment.systemPackages = with pkgs; [
     git
     vim-full
     fastfetch
     btop
     gdu
     tree
     wget
     curl
     nix-output-monitor
     net-tools
     nethogs
     bat
     pciutils
     nvme-cli
     cdrtools
     ntfs3g
     nix-search
   ];

  # Allow some unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg)
  [
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
    "unrar"
    "mongodb-ce"
  ];
  
  system.stateVersion = "25.11"; # Do NOT Change.

}

