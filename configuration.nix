{ config, lib, pkgs, ... }:
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
  # Garbage Collection of old generations
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
 # To limit resources used during building the system
 nix.settings = {
  max-jobs = 3;
  cores = 3;
};
  # Boot loader and some stuff.
   boot = {
   #kernelParams = [ "quiet" ];
   # By default, the latest LTS linux kernel is installed 
   kernelPackages = pkgs.linuxPackages_latest; # The linux kernel to boot with
   supportedFilesystems = [ "nfs" ]; # to have NFS support
   loader = {
   timeout = 1;
   grub = {
    enable = true;
    efiSupport = true;
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
   time.timeZone = "Africa/Egypt";

 # Doas instead of Sudo
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = ["khaled"];
    keepEnv = true;
    persist = true;
  }];

  users.users.khaled = {
    isNormalUser = true;
    description = "Khaled M. Hosny";
    extraGroups = [ "networkmanager" "libvirtd" "ydotool" "video" "render" ];
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
   ];

  # Allow some unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg)
  [
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
  ];

  system.stateVersion = "25.11"; # Do NOT Change.

}

