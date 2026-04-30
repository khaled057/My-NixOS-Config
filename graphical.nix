{config, pkgs, ...}: {
  imports = [
    ./waydroid.nix
    ./fontconfig.nix
  ];
 security.polkit.enable = true;
 security.rtkit.enable = true;
 services.getty = {
  autologinUser = "khaled";
  autologinOnce = true;
};
   environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
'';

  # Enable Sound
   services.pipewire = { 
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
};
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
 services.flatpak.enable = true; # Needed for nix-flatpak to work
 services.gnome.gnome-keyring.enable = true;
 security.pam.services = {
  greetd.enableGnomeKeyring = true;
  swaylock.enableGnomeKeyring = true;
};
  # XDG desktop portal
 xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk 
    ];

    config.common = {
      default = [ "gtk" ];
    };
  }; 
   # Will fix links not opening in sway or in NixOS in general
   systemd.user.extraConfig = '' 
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  ''; 
  # Thunar
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
  thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
  thunar-volman
];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  
  # Syncthing 
  services.syncthing = { 
    enable = true;
    user = "khaled";
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    dataDir = "/home/khaled";  # default location for new folders
    configDir = "/home/khaled/.config/syncthing";
    overrideDevices = false;
    overrideFolders = false;
    settings.options = {
     urAccepted = -1;
    };
  };
  # Ydotool
  programs.ydotool.enable = true;
  # Nvidia
   # To make wlroots based compositors use Intel gpu
   environment.sessionVariables = { 
     WLR_DRM_DEVICES = "/dev/dri/intel-igpu";
     LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
   };
  services = {
    xserver.videoDrivers = 
    [
      "modesetting"
      "nvidia"
    ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver     # VA-API (iHD) userspace
      vpl-gpu-rt             # oneVPL (QSV) runtime
    ];
  };
  hardware.nvidia.open = true; # Use Nvidia Open-source Modules
  hardware.nvidia.modesetting.enable = true; # Enable Nvidia Modesetting for Wayland
  hardware.nvidia.prime = {
    offload = { 
    enable = true;
    enableOffloadCmd = true; # Enable nvidia-offload Script
  };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  programs.gamemode.enable = true;
  # Printing Support
  services.ipp-usb.enable = true;
  services.avahi = {
   enable = true;
   nssmdns4 = true;
   openFirewall = true;
};

  services.printing = {
   enable = true;
   drivers = with pkgs; [
    cups-filters
    cups-browsed
  ];
};

 
  # Appimages 
  programs.appimage = {
   enable = true;
   binfmt = true;
   package = pkgs.appimage-run.override
   {
    extraPkgs = pkgs:
    [
    pkgs.icu
    pkgs.libxcrypt-legacy
    pkgs.python312
    pkgs.python312Packages.torch
    ];
};

 };

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
  # Firewall
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  # Custom udev rules
  services.udev.extraRules = ''
  # Intel GPU
  SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:00:02.0", SYMLINK+="dri/intel-igpu"

  # NVIDIA GPU
  SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-dgpu"
  '';
}

