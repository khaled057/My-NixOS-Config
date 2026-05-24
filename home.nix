{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./sway/rofi.nix
    ./sway/waybar.nix
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  # paths Home Manager should manage.
  home.username = "khaled";
  home.homeDirectory = "/home/khaled";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [ 
    wl-clipboard
    steam-devices-udev-rules
    android-tools
    dnsmasq
    htop
    brightnessctl
    grim
    slurp
    gcc
    libnotify
    jq
    unrar
    file-roller
    mesa-demos
    # support both 32-bit and 64-bit applications
    wineWow64Packages.stable
    # winetricks (all versions)
    winetricks
    # Desktop apps
    libreoffice-fresh
    librewolf
    brave
    distroshelf
    protonvpn-gui
    waydroid-helper
    pwvucontrol
    evince
    tauon
    blueberry
    bitwarden-desktop
    mars-mips
    video-downloader
    logseq
    gnome-pomodoro
  ];
  # NetworkManager applet
  services.network-manager-applet.enable = true;
  # Kitty 
  programs.kitty = {
    enable = true;
    font = { 
     name = "FiraCode Nerd Font";
     size = 18;
   };
    themeFile = "adwaita_dark";
  };
  # Vim
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      nnoremap <F5> :w<CR>:!g++ % -o %< && ./%<<CR>
      set mouse=a
      set laststatus=0
    '';
  };
  # Looking-glass
  programs.looking-glass-client = {
    enable = true;
    settings = {
     app = {
    allowDMA = true;
    shmFile = "/dev/kvmfr0";
  };

    win = {
    fullScreen = true;
    showFPS = false;
    jitRender = false;
  };

   spice = {
    enable = true;
    audio = true;
  };

   input = {
    rawMouse = true;
    escapeKey = 62;
  };
    
    };
  };
  # Freetube
  programs.freetube = {
   enable = true;
   settings = {
    enableSearchSuggestions = false;
    checkForUpdates = false;
    autoplayVideos = false;
    autoplayPlaylists = false;
    defaultQuality = "360";
    hideUpcomingPremieres = true;
    hideTrendingVideos = true;
    playNextVideo = false;
    hideRecommendedVideos = true;
    hideCommentPhotos = true;
    watchedProgressSavingMode = "never";
    rememberHistory = false;
    rememberSearchHistory = false;
    useSponsorBlock = true;
    useDeArrowTitles = true;
   };
  
  
  };
  # MPV
  programs.mpv.enable = true;
  # Swww
  services.swww.enable = true; 
  # wl-clip-persist
  services.wl-clip-persist.enable = true;
  # Swaync (Notification daemon)
  services.swaync = {
  enable = true;
  };
  # Satty (annotation tool) 
  programs.satty = {
    enable = true;
    settings = {
    general = {
    fullscreen = true;
    corner-roundness = 12;
    initial-tool = "brush";
    output-filename = "~/Pictures/%Y-%m-%d_%H:%M:%S.png";
  };
  color-palette = {
    palette = [ "#00ffff" "#a52a2a" "#dc143c" "#ff1493" "#ffd700" "#008000" ];
  };
  };
  };
  # Librewolf
  /*programs.librewolf = {
    enable = true;
    settings = {
      "privacy.resistFingerprinting.letterboxing" = true;
      "webgl.disabled" = true;
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
    };
    policies = {
    ExtensionSettings = {
    "uBlock0@raymondhill.net" = {
      default_area = "menupanel";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
    "addon@darkreader.org" = {
     install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
     default_area = "menupanel";
     installation_mode = "force_installed";
     private_browsing = "true";
    };
    };
  };
  profiles.default = {
  isDefault = true;
  name = " Default Profile";
  search = {
    default = "startpage";
    privateDefault = "startpage";
  };
  };
  };*/
  # Lutris
  programs.lutris = {
    enable = true;
    package = pkgs.lutris-free;
    defaultWinePackage = pkgs.proton-ge-bin;
    protonPackages = [ pkgs.proton-ge-bin ]; # The default Compatiblity layer to use.
  };
  # Bash
  programs.bash.enable = true;
  programs.bash.shellAliases = {
  rb="doas nixos-rebuild switch 2>&1 | nom";
  conf="doas vim /etc/nixos/configuration.nix";
  u="doas nix flake update --flake /etc/nixos && doas nixos-rebuild switch 2>&1 | nom && flatpak update && doas waydroid upgrade";
  rm="rm -i";
  server="doas mount -t nfs4 192.168.1.60:/ Home-Server";
  fastfetch="fastfetch -l nixos_old";
  hs="TERM=kitty ssh home-server";
  sudo="doas";
    hows-my-gpu = ''
    echo "=== NVIDIA ==="
    lspci -nnk -d 10de: | sed -n '/VGA/,/^[0-9]/p' | grep -E "Kernel driver in use|Kernel modules"

    echo "=== Intel ==="
    lspci -nnk -d 8086: | sed -n '/VGA/,/^[0-9]/p' | grep -E "Kernel driver in use|Kernel modules"

    echo "=== Active OpenGL renderer ==="
    glxinfo -B | grep "OpenGL renderer"
  '';

  nvidia-enable = ''sudo virsh nodedev-reattach pci_0000_01_00_0; echo "GPU reattached (now host ready)"; sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1 vfio; echo "VFIO drivers removed"; sudo modprobe -i nvidia_drm nvidia_modeset nvidia; echo "NVIDIA drivers added"; echo "COMPLETED! (confirm success with hows-my-gpu)"'';

  nvidia-disable = ''sudo rmmod nvidia_drm nvidia_modeset nvidia; echo "NVIDIA drivers removed"; sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1 vfio; echo "VFIO drivers added"; sudo virsh nodedev-detach pci_0000_01_00_0; echo "GPU detached (now vfio ready)"; echo "COMPLETED! (confirm success with hows-my-gpu)"'';
};
  # Default Apps

  # GTK
  gtk = {
   enable = true;
   colorScheme = "dark";
   theme = {
    name = "Flat-Remix-GTK-Blue-Dark";
    package = pkgs.flat-remix-gtk;
   };
   iconTheme = {
    name = "Flat-Remix-Blue-Dark";
    package = pkgs.flat-remix-icon-theme;
   };
   cursorTheme = {
    name = "Catppuccin-Mocha-Light-Cursors";
    package = pkgs.catppuccin-cursors.mochaLight;
  };
};
  # QT
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
     name = "Flat-Remix-GTK-Blue-Dark";
     package = pkgs.flat-remix-gtk;
    };
  };

  # Cursor
  home.pointerCursor = {
    gtk.enable = true; # To tell GTK apps to use this cursor
    sway.enable = true; # To let sway use this cursor
    x11 = {
      enable = true;
      defaultCursor = "Catppuccin-Mocha-Light-Cursors";
    };
    name = "Catppuccin-Mocha-Light-Cursors";
    package = pkgs.catppuccin-cursors.mochaLight;
    size = 34;
  };

  # Create XDG User Directories
  xdg.userDirs.enable = true; 
  xdg.userDirs.createDirectories = true; # Whether to enable automatic creation of the XDG user directories.
  
  # Distrobox
  programs.distrobox.enable = true;
  # Sway
  wayland.windowManager.sway = {
  enable = true;
  systemd.variables = ["--all"]; # to make Sway inherit the user environment when launched from TTY
  wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
 # extraSessionCommands = "export WLR_DRM_DEVICES=/dev/dri/by-path/pci-0000:00:02.0-render";
   config = rec {
     modifier = "Mod4";
     menu = "rofi -show drun";
     terminal = "kitty"; 
     defaultWorkspace = "workspace number 1";
     window = {
       titlebar = false;
       commands = [
         {
        criteria = { app_id = "kitty";};
        command = "opacity 0.85";
      }
      {
        criteria = { class = "Thunar";};
        command = "opacity 0.90";
      }
      {
        criteria = { floating = true; };
        command = "opacity 0.95";
      }
      ];
     };
     workspaceAutoBackAndForth = true;
     keybindings = let
        filemanager = "thunar"; 
        browser = "brave";
    in lib.mkOptionDefault {
      "${modifier}+q" = "exec ${terminal}";
      "${modifier}+c" = "kill";
      "${modifier}+r" = "exec ${menu}";
      "${modifier}+e" = "exec ${filemanager}";
      "${modifier}+b" = "exec ${browser}";
      "${modifier}+n" = "exec logseq";
      "${modifier}+Shift+r" = "exec reboot";
      "${modifier}+Shift+h" = "exec shutdown now";
      "${modifier}+Shift+p" = "exec systemctl suspend";
      "${modifier}+Shift+o" = "exec waydroid session stop";
      "${modifier}+Shift+w" = "exec waydroid show-full-ui";
      "${modifier}+Shift+l" = "exec ~/Scripts/awww_randomize.sh";
      "${modifier}+Shift+g" = "exec looking-glass-client";
      "${modifier}+v" = "exec cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy";
      "${modifier}+Shift+f" = "floating toggle";
      # Screenshot a selection and use satty for other things 
      "Print" = "exec grim -g \"$(slurp)\" - | satty -f -";
      "Scroll_Lock" = "exec ~/Scripts/autoclick.sh";
      "End" = "exec pkill -F /tmp/autoclick.pid";

};
     bars = [{ command = "swaybar_command waybar"; }];

     input = {
        "type:touchpad" = {
        # Enables or disables tap for specified input device.
        tap = "enabled";
        # Enables or disables natural (inverted) scrolling for the specified input device.
        natural_scroll = "disabled";
        # Enables or disables disable-while-typing for the specified input device.
        dwt = "enabled";
      };
    };
  };
   extraOptions = [ "--unsupported-gpu" ];
};

  # Polkit 
  services.hyprpolkitagent.enable = true;

  services.cliphist.enable = true; 
  programs.swayimg.enable = true;
  # Fcitx5
  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.inputMethod.fcitx5.settings = {
   inputMethod = {
    GroupOrder."0" = "Default";
     "Groups/0" = {
      Name = "Default";
      "Default Layout" = "us";
      DefaultIM = "keyboard-us";
    };
    "Groups/0/Items/0".Name = "keyboard-us";
    "Groups/0/Items/1".Name = "keyboard-eg";
    "Groups/0/Items/2".Name = "pinyin";
   };
   globalOptions = {
     Hotkey = {
       EnumerateWithTriggerKeys = true;
       EnumerateSkipFirst = false;
       ModifierOnlyKeyTimeout = 250;
     };

       "Hotkey/TriggerKeys" = {
            "0" = "Control+Shift+space";
            "1" = "Zenkaku_Hankaku";
            "2" = "Hangul";
          };
       "Hotkey/ActivateKeys"."0" = "Hangul_Hanja";
       "Hotkey/DeactivateKeys"."0" = "Hangul_Romaja";
       "Hotkey/AltTriggerKeys"."0" = "Shift_L";
       "Hotkey/EnumerateGroupForwardKeys"."0" = "Super+space";
       "Hotkey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
       "Hotkey/PrevPage"."0" = "Up";
       "Hotkey/NextPage"."0" = "Down";
       "Hotkey/PrevCandidate"."0" = "Shift+Tab";
       "Hotkey/NextCandidate"."0" = "Tab";
       "Hotkey/TogglePreedit"."0" = "Control+Alt+P";
        Behavior = {
          ActiveByDefault = true;
          resetStateWhenFocusIn = "No";
          ShareInputState = "All";
          PreeditEnabledByDefault = true;
          ShowInputMethodInformation = true;
          showInputMethodInformationWhenFocusIn = false;
          CompactInputMethodInformation = true;
          ShowFirstInputMethodInformation = true;
          DefaultPageSize = 5;
          OverrideXkbOption = true;
          PreloadInputMethod = true;
          AllowInputMethodForPassword = false;
          ShowPreeditForPassword = false;
          AutoSavePeriod = 30;
        };
      };

    };
    i18n.inputMethod.fcitx5.addons = with pkgs; [ 
      fcitx5-gtk 
      kdePackages.fcitx5-configtool 
      kdePackages.fcitx5-chinese-addons 
      fcitx5-inflex-themes
    ];
  i18n.inputMethod.fcitx5.waylandFrontend = true;
      # SSH
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "home-server" = {
              hostname = "192.168.1.60";
              user = "khaled";
              port = 5432;
              identityFile = [ "~/.ssh/another-machine" ];
              identitiesOnly = true;
            };
          };
   };
  # Declartive Flatpaks
  # By default Flathub repo is added.
    services.flatpak.packages = [
   "it.mijorus.gearlever"
   "com.github.tchx84.Flatseal"
   "network.loki.Session"
   "com.discordapp.Discord"
   "com.valvesoftware.Steam"
   "com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
   "io.github.jonmagon.kdiskmark"
   "com.heroicgameslauncher.hgl"
  ];

  home.stateVersion = "25.11"; # Do NOT change

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

