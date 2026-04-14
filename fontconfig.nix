{ config, pkgs, libs, ...}:{
 fonts = {
  packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  nerd-fonts.fira-code
];
fontconfig = {
    localConf = ''
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <!-- Fallback fonts preference order -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Kufi Arabic</family>
      <family>Open Sans</family>
      <family>Droid Sans</family>
      <family>Roboto</family>
      <family>Tholoth</family>
      <family>Noto Sans Arabic</family>
    </prefer>
  </alias>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Kufi Arabic</family>
      <family>Droid Serif</family>
      <family>Roboto Slab</family>
      <family>Tholoth</family>
      <family>Noto Sans Arabic</family>
    </prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Kufi Arabic</family>	   
      <family>Noto Sans Mono</family>
      <family>Inconsolata</family>
      <family>Droid Sans Mono</family>
      <family>Roboto Mono</family>
    </prefer>
  </alias>
  <match target="font">
    <edit name="embeddedbitmap" mode="assign">
      <bool>false</bool>
    </edit>
  </match>
  <match target="pattern">
    <test name="lang" compare="contains">
      <string>ar</string>
    </test>
    <test qual="any" name="family">
      <string>serif</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Kufi Arabic</string>
    </edit>
  </match>
   <match target="pattern">
    <test name="lang" compare="contains">
      <string>ar</string>
    </test>
    <test qual="any" name="family">
      <string>sans-serif</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Kufi Arabic</string>
    </edit>
  </match> 
  <match target="pattern">
    <test name="lang" compare="contains">
      <string>ar</string>
    </test>
    <test qual="any" name="family">
      <string>monospace</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Kufi Arabic</string>
    </edit>
  </match>
  <match>
    <test name="lang" compare="contains">
      <string>zh</string>
    </test>
    <test name="family">
      <string>serif</string>
    </test>
    <edit name="family" mode="prepend">
      <string>Noto Serif CJK SC</string>
    </edit>
  </match>
  <match>
    <test name="lang" compare="contains">
      <string>zh</string>
    </test>
    <test name="family">
      <string>sans-serif</string>
    </test>
    <edit name="family" mode="prepend">
      <string>Noto Sans CJK SC</string>
    </edit>
  </match>
  <match>
    <test name="lang" compare="contains">
      <string>zh</string>
    </test>
    <test name="family">
      <string>monospace</string>
    </test>
    <edit name="family" mode="prepend">
      <string>Noto Sans Mono CJK SC</string>
    </edit>
  </match>
  <!--WenQuanYi Zen Hei -> WenQuanYi Micro Hei -->
  <match target="pattern">
    <test qual="any" name="family">
      <string>WenQuanYi Zen Hei</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei</string>
    </edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family">
      <string>WenQuanYi Zen Hei Lite</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei Lite</string>
    </edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family">
      <string>WenQuanYi Zen Hei Mono</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei Mono</string>
    </edit>
  </match>
  <!--Microsoft YaHei, SimHei, SimSun -> WenQuanYi Micro Hei -->
  <match target="pattern">
    <test qual="any" name="family">
      <string>Microsoft YaHei</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei</string>
    </edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family">
      <string>SimHei</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei</string>
    </edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family">
      <string>SimSun</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei</string>
    </edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family">
      <string>SimSun-18030</string>
    </test>
    <edit name="family" mode="assign" binding="same">
      <string>WenQuanYi Micro Hei</string>
    </edit>
  </match>
</fontconfig>  '';
  };
};
}

