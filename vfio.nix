{ pkgs, config, lib, ...}:{
  myModules.vfio.stealth = {
  enable = true;
  smbios = {
    manufacturer = "LENEVO";
    product = "83GS";
    biosVendor = "LENOVO";
    biosVersion = "NECN50WW";
    biosDate = "01/16/2026";
    biosRelease = "3.4";
    baseBoardVersion = "Rev 1.04";
    baseBoardSerial = "MP2GLVRK";
    serial = "MP2GLVRK";
    baseBoardAsset = "baseBoardAsset";
    baseBoardLocation = "Type2 - Board Chassis Location";
    onboardDevices = [
     {
    designation = "IGD";
    kind = "Video";
    instance = 1;
     } 
    ];
    socketPrefix = "U3E1";
    cache = {
      l1 = 256;
      l2 = 2048;
      l3 = 12288;
      ecc = 6;
    };
    oemStrings = [
      "Country - .."
      "Modern Preload"
      "83GS"
      "Default string"
    ];
    memory = {
      manufacturer = "Samsung";
      partNumber = "M425R1GB4PB0-CWMOD";
      speed = 5600;
      count = 2;
    };
  };
    disk = {
    model = "Micron MTFDKCD512QFM-1BD1AABLA    ";
    serial = "2342444948FC";
    opticalModel = "HL-DT-ST DVDRAM GH24NSC0";
    };
    edid = {
     manufacturer = "BOE";
     serial = "103";
     productCode = "0x00000067";
     dpi = 141;
     week = 17;
     year = 2023;
    };
  macPrefix = "2c:f0:5d";  # Peplink OUI
  hypervVendorId = "GenuineIntel";

};
    # Custom Patched linux Kernel
  boot.kernelPackages = pkgs.linuxPackagesFor (
  pkgs.linuxPackages_latest.kernel.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + config.myModules.vfio.stealth._kernelPostPatch;
  })
);
# QEMU overlay with matching hardware strings
nixpkgs.overlays = [
  (final: prev: {
    qemu-stealth = prev.qemu-stealth.override {
      edidManufacturer = "BOE";
      edidSerial = "103";
      edidProductCode = "0x00000067";
      edidDpi = 141;
      edidWeek = 17;
      edidYear = 2023;
      acpiOemId = "MSI_NB";
      acpiOemTableId = "MEGABOOK";
      diskModel = "Micron MTFDKCD512QFM-1BD1AABLA    ";
      diskSerial = "2342444948FC";
      opticalModel = "HL-DT-ST DVDRAM GH24NSC0";
    };
  })
];
}
