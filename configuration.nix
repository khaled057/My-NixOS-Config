{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fontconfig.nix
      ./waydroid.nix
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
  # Boot loader and some stuff.
   boot = {
   kernelParams = [ "quiet" ];
   kernelPackages = pkgs.linuxPackages_latest; # The linux kernel to boot with
   initrd.luks.devices."luks-5abdf389-39dd-425b-8c0d-05771b472a20".device = "/dev/disk/by-uuid/5abdf389-39dd-425b-8c0d-05771b472a20";
   supportedFilesystems = [ "nfs" ]; # to have NFS support
   loader = {
  # efi.canTouchEfiVariables = true;
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
   networking = {
   hostName = "nixos"; # Define your hostname.
   networkmanager.enable = true; # Enables NetworkManager
   firewall.trustedInterfaces = [ "virbr0"  ]; # Firewall
   };
  # Set your time zone.
   time.timeZone = "Africa/Cairo";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  hardware.nvidia.open = true; # Use Nvidia Open-source Modules
  hardware.nvidia.modesetting.enable = true; # Enable Nvidia Modesetting for Wayland
  hardware.nvidia.prime.offload.enableOffloadCmd = true; # Enable nvidia-offload Script
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };
  services = {
    xserver.videoDrivers = 
    [
      "modesetting"
      "nvidia"
    ];
  pipewire = { # Enable Sound with pipewire
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
};
  displayManager.sddm.enable = true; # Enable SDDM Display Manager
  desktopManager.plasma6.enable = true; # Enable the KDE Plasma Desktop Environment
  # Some Networking stuff for printing
  ipp-usb.enable = true;
  avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};
  # Enable CUPS to print documents
  printing = { 
  enable = true;
  drivers = with pkgs; [
    cups-filters
    cups-browsed
  ];
};
  # Syncthing
    syncthing = { 
    enable = true;
    user = "khaled";
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    dataDir = "/home/khaled";  # default location for new folders
    configDir = "/home/khaled/.config/syncthing";
  };
  };
  hardware.bluetooth.enable = true; # Bluetooth Support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.rtkit.enable = true;
  # Doas instead of Sudo
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = ["khaled"];
    # Optional, retains environment variables while running commands
    # e.g. retains your NIX_PATH when applying your config
    keepEnv = true;
    persist = true;
  }];
    # If using a flakes-based configuration, you'll need `git` in your system packages for system rebuilds
  # Fcitx5
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      kdePackages.fcitx5-configtool
      kdePackages.fcitx5-chinese-addons
    ];
};
# Windows 7 look
/*boot.plymouth.enable = true;
services.displayManager.defaultSession = "aerothemeplasma";
programs = {
linver.enable = true;
execbin.enable = true;
aeroshell = {
  enable = true; 
  fonts.enable = true; 
  polkit.enable = true;
  aerothemeplasma = {
    enable = true; 
    sddm.enable = true;
    plymouth.enable = true; 
  };
};
};*/
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
  khaled = {
    isNormalUser = true;
    description = "Khaled M. Hosny";
    extraGroups = [ "networkmanager" "libvirtd" ];
    packages = with pkgs; [
    ];
  };
};
  # Allow some unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg)
  [
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
  ];
   # List packages installed in system profile.
   environment.systemPackages = with pkgs; [
    vim-full 
    fastfetch
    librewolf
    gdu
    tree
    wget
    curl
    nix-output-monitor
    dnsmasq
    swtpm
    freetube
    protonvpn-gui 
    libreoffice-fresh
    mpv
    distrobox
    kontainer
    ferdium
    video-downloader
    wl-clipboard
    joplin-desktop
    android-tools
    ocs-url
    kdePackages.qtstyleplugin-kvantum
    kdePackages.oxygen
    kdePackages.oxygen-sounds
    git
    waydroid-helper
    heroic
    gnome-solanum
    net-tools
    lutris-free
    steam-devices-udev-rules
  ];
 programs.gamemode.enable = true;
 hardware.graphics.enable32Bit = true; #  If you're running a 64bit environment you need to ensure that you enable 32bit support
 # OBS Studio
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true; # Enable Virtual Camera
    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

 # Appimages 
 programs.appimage = {
  enable = true;
  binfmt = true;
};
 # Flatpak
  services.flatpak.enable = true;
  # By default nix-flatpak will add the flathub remote.
  services.flatpak.packages = # Declare Flatpak packages
  [ 
   "it.mijorus.gearlever"
   "com.github.tchx84.Flatseal"
   "com.discordapp.Discord"
   "network.loki.Session"
   "com.valvesoftware.Steam"
   "com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
  ];
  # Virtualization
  virtualisation = {
  podman = {
  enable = true;
  dockerCompat = true;
};
  # Enable USB redirection
  spiceUSBRedirection.enable = true; 
  libvirtd = {
  enable = true;
  qemu.swtpm.enable = true; # Allow Qemu to use swtpm to create Emulated TPM
  qemu.vhostUserPackages = [ pkgs.virtiofsd ]; # Packages containing out-of-tree vhost-user drivers.
};
};
  programs.virt-manager.enable = true;

  system.stateVersion = "25.11"; 
}

