{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./sway/rofi.nix
    ./sway/waybar.nix
    #./sway.nix
  ];

  # paths Home Manager should manage.
  home.username = "khaled";
  home.homeDirectory = "/home/khaled";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [ 
    kdePackages.ark
    wl-clipboard
    steam-devices-udev-rules
    android-tools
    dnsmasq
    htop
    brightnessctl
    grim
    slurp
    gcc
    # Desktop apps
    libreoffice-fresh
    librewolf
    kontainer
    protonvpn-gui
    waydroid-helper
    pwvucontrol
    evince
    tauon
    blueberry
    bitwarden-desktop
    mars-mips
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
  # Joplin-desktop
  programs.joplin-desktop.enable = true;
  programs.joplin-desktop.sync.target  = "file-system";
  # Freetube
  programs.freetube.enable = true;
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
 /* programs.librewolf = {
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
    "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
     install_url = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
     default_area = "menupanel";
     installation_mode = "force_installed";
     private_browsing = "true";
    };
    };
  };
  profiles.default = {
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
  #ssh="kitten ssh";
  hs="TERM=kitty ssh -p 5432 192.168.1.60";
  sudo="doas";
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
        criteria = { app_id = "kitty"; };
        command = "opacity 0.85";
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
        browser = "librewolf";
    in lib.mkOptionDefault {
      "${modifier}+q" = "exec ${terminal}";
      "${modifier}+c" = "kill";
      "${modifier}+r" = "exec ${menu}";
      "${modifier}+e" = "exec ${filemanager}";
      "${modifier}+b" = "exec ${browser}";
      "${modifier}+n" = "exec joplin-desktop";
      "${modifier}+Shift+r" = "exec reboot";
      "${modifier}+Shift+h" = "exec shutdown now";
      "${modifier}+Shift+o" = "exec waydroid session stop";
      "${modifier}+Shift+l" = "exec ~/Scripts/awww_randomize.sh";
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
  services.swayosd = {
   enable = true;
   # OSD Margin from the top edge, 0.5 would be the screen center. May be from 0.0 - 1.0.
   topMargin = 0.9;
};
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
    /*addons = {
    g
    
    };*/
    };
    i18n.inputMethod.fcitx5.addons = with pkgs; [ 
      fcitx5-gtk 
      kdePackages.fcitx5-configtool 
      kdePackages.fcitx5-chinese-addons 
      fcitx5-inflex-themes
    ];
  i18n.inputMethod.fcitx5.waylandFrontend = true;
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
  ];

  home.stateVersion = "25.11"; # Do NOT change

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

