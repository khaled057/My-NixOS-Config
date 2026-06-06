{  lib, pkgs, nixpkgs-unstable,...}:
# Applying a patch for QEMU to Hide VM from Anti-Cheat
let
  unstable = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  edk2-anti = pkgs.edk2.overrideAttrs (old: {
   /*  src = pkgs.fetchFromGitHub {
     owner = "tianocore";
     repo = "edk2";
     rev = "edk2-stable202602";
     hash = "sha256-rY48qHjca8nA9uMOyc8cqGIwkYHfWxCbQIKIomtCIK0=";
  };*/
    patches =  [./Intel-edk2-stable202602.patch];
});
 
  qemu-anti = pkgs.qemu.overrideAttrs (old: {    
     src = pkgs.fetchFromGitHub {
     owner = "qemu";
     repo = "qemu";
     tag = "v11.0.0";
     hash = "sha256-rY48qHjca8nA9uMOyc8cqGIwkYHfWxCbQIKIomtCIK0=";
    };
     edk2 = edk2-anti;
});
in

{


  virtualisation = {
  podman = {
  enable = true;
  dockerCompat = true;
};
  # Enable USB redirection
  spiceUSBRedirection.enable = true;
    libvirtd = {
     enable = true;
      qemu = {
       package = qemu-anti;
       swtpm.enable = true; # Allow Qemu to use swtpm to create Emulated TPM
       vhostUserPackages = [ pkgs.virtiofsd ]; # Packages containing out-of-tree vhost-user drivers.
  };
    deviceACL = [
      "/dev/kvm"
      "/dev/kvmfr0"
      "/dev/kvmfr1"
      "/dev/kvmfr2"
      "/dev/shm/looking-glass"
      "/dev/null"
      "/dev/full"
      "/dev/zero"
      "/dev/random"
      "/dev/urandom"
      "/dev/ptmx"
      "/dev/kvm"
      "/dev/kqemu"
      "/dev/rtc"
      "/dev/hpet"
      "/dev/vfio/vfio"
    ];
  };
  vfio = {
    enable = true;
    IOMMUType = "intel";
    devices = [
        "10de:25ed"
        "10de:2291"
      ];
  };

   kvmfr = {
    enable = true;
    devices = lib.singleton {
      size = 32;
      permissions = {
        group = "kvm";
        mode = "0660";
      };
    };
  };
};
  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
    "nouveau"
  ];

  programs.virt-manager.enable = true;
  # Bridge Networks in VMs

  systemd.network = {
    enable = true;
    wait-online.enable = false; # so that boot isn't blocked on connectivity that networkd will never provide in the case networkmanager and systemd-networkd will both manage the network.

    netdevs = {
      # Create the bridge interface
    "10-br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };
  };

    networks = {
      # Connect the NIC ports to the bridge  
      "10-enp7s0" = {
        matchConfig.Name = "enp7s0";
        networkConfig = {
          Bridge = "br0";
        };
        linkConfig.RequiredForOnline = "enslaved";
      };
      
      # Host networking now lives on bridge
      "20-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
