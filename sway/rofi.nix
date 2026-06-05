{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;

    extraConfig = {
      font = "FiraCode Nerd 20";
      line-margin = 10;
      show-icons = true;
      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-window = "";
      display-combi = "";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        # Flat Remix palette
        bg0 = mkLiteral "#212121F2";
        bg1 = mkLiteral "#2A2A2A";
        bg2 = mkLiteral "#3D3D3D80";
        accent = mkLiteral "#1A73E8";

        fg0 = mkLiteral "#E6E6E6";
        fg1 = mkLiteral "#FFFFFF";
        fg2 = mkLiteral "#A8A8A8";

        border = mkLiteral "#3A3A3A";

        background-color = mkLiteral "transparent";
        foreground = mkLiteral "@fg0";
      };

      "window" = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        transparency = "screenshot";
        padding = 12;
        border = 0;
        border-radius = 12;
        width = mkLiteral "60%";

        background-color = mkLiteral "transparent";
        spacing = 0;
        children = [ "mainbox" ];
      };

      "mainbox" = {
        spacing = 0;
        children = [ "inputbar" "listview" ];
      };

      "inputbar" = {
        padding = 12;
        background-color = mkLiteral "@bg1";

        border = 1;
        border-radius = mkLiteral "12px 12px 0px 0px";
        border-color = mkLiteral "@border";

        color = mkLiteral "@fg1";
      };

      "entry" = {
        text-font = mkLiteral "inherit";
        text-color = mkLiteral "@fg1";
      };

      "prompt" = {
        margin = mkLiteral "0px 1em 0em 0em";
        text-color = mkLiteral "@fg2";
      };

      "listview" = {
        padding = 8;
        lines = 8;
        columns = 1;

        border = mkLiteral "0px 1px 1px 1px";
        border-radius = mkLiteral "0px 0px 12px 12px";
        border-color = mkLiteral "@border";

        background-color = mkLiteral "#212121E6";
        dynamic = false;
      };

      "element" = {
        padding = 6;
        vertical-align = mkLiteral "0.5";
        border-radius = 8;

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
      };

      # Hover (GTK subtle highlight)
      "element normal active" = {
        background-color = mkLiteral "#2F2F2F";
        text-color = mkLiteral "@fg1";
      };

      # Selected (Flat Remix blue)
      "element selected normal" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "#FFFFFF";
      };

      "element-text" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "element-icon" = {
        size = 48;
        background-color = mkLiteral "inherit";
      };

      "textbox" = {
        padding = 8;
        border-radius = 10;

        border = mkLiteral "1px";
        border-color = mkLiteral "@border";

        background-color = mkLiteral "@bg1";
        text-color = mkLiteral "@fg0";
      };
    };
  };
}
