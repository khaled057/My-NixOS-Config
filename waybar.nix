{ pkgs, config, lib, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
     mainBar = {
       layer = "top";
       position = "top";
       margin-bottonm = 0;
       margin-top = 0;
       modules-left = [ "cpu" "temperature" "sway/mode" "memory" "network" "mpd" ];
       modules-center = [ "sway/workspaces" ];
       modules-right = [ "tray" "pulseaudio" "pulseaudio#microphone" "backlight" "battery"  "clock" ];
       # Modules Configuration
       "sway/workspaces" = {
         disable-scroll = true;
         all-outputs = true;
         sort-by-name = true;
         on-click = "activate";
       };
       "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
       };
       "sway/window" = {
         max-length = 200;
         separate-outputs = true;
       };
       "battery" = {
        states = {
         warning = 30;
         critical = 15; 
       };
        format = "{icon}&#8239;{capacity}%";
        format-charging = "&#8239;{capacity}%";
        format-plugged = "&#8239;{capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["" "" "" "" "" "" ""];
       };
       "tray" = {
         icon-size = 22;
         spacing = 6;
       };
       "clock" = {
         locale = "C"; 
         format = " {:%H:%M}";
         format-alt = " {:%a,%b %d}"; # Icon: calendar-alt
         tooltip-format = "<tt><small>{calendar}</small></tt>";
         calendar = {
          format = {
          months = "<span color='#ffead3'><b>{}</b></span>";
          today = "<span color='#ff6699'><b>{}</b></span>";
    };
  };
       };
       "cpu" = {
        format = "  {usage}%";
        tooltip = false;
        on-click = "kitty -e 'htop'";
       };
       "memory" = {
        interval = 30;
        format = "  {used:0.2f}GB";
        max-length = 10;
        tooltip = false;
        warning = 70;
        critical = 90;
       };
       "temperature" = {
         interval = "4";
         hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
         critical-threshold = 74;
         format-critical = "  {temperatureC}°C";
         format = "{icon} {temperatureC}°C";
         format-icons = ["" "" ""];
         max-length = 7;
         min-length = 7;
       };
       "network" = {
         interval = 2;
         format-wifi = "  {signalStrength}%";
         format-linked = "{ipaddr}";
         format-ethernet = "";
         format-disconnected = " Disconnected";
         format-disabled = "";
         tooltip = false;
         max-length = 20;
         min-length = 6;
         format-alt = "{essid}";
       };
       "backlight" = {
         format = "{icon}{percent}%";
         format-icons = [" " " "];
         on-scroll-down = "brightnessctl -c backlight set 1%-";
         on-scroll-up = "brightnessctl -c backlight set +1%";
       };
       "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "  muted";
        format-icons = {
         headset = "";
         default = [" " " " " "];
    };
        on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";       
        on-scroll-up = "wpctl set-volume --limit 1.52 @DEFAULT_SINK@ 1%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_SINK@ 1%-";
       };
       "pulseaudio#microphone" = {
         format = "{format_source}";
         format-source = " {volume}%";
         format-source-muted = "  muted";
         on-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
         on-scroll-up = "wpctl set-volume --limit 1.52 @DEFAULT_SOURCE@ 1%+";
         on-scroll-down = "wpctl set-volume @DEFAULT_SOURCE@ 1%-";
       };
       "mpd" = {
         format = "{stateIcon} {artist} - {title}";
         format-disconnected = "🎶";
         format-stopped = "♪";
         interval = 10;
         consume-icons = {
          on = " "; # Icon shows only when "consume" is on
        };
      };       
      "random-icons" = {
        off = "<span color=\"#f53c3c\"></span> "; # Icon grayed out when "random" is off
        on = " ";
      };       
      "repeat-icons" = {
        on = " ";
  };
      "single-icons" = {
        on = "1 ";
  };
      "state-icons" = {
        paused = "";
        playing = "";
  };
      "tooltip-format" = "MPD (connected)";
      "tooltip-format-disconnected" = "MPD (disconnected)";
      "max-length" = 35;
      "custom/recorder" = {
       format = " Rec";
       format-disabled = " Off-air"; # An empty format will hide the module.
       return-type = "json";
       interval = 1;
       exec = "echo '{\"class\": \"recording\"}'";
       exec-if = "pgrep wf-recorder";
};
    "custom/audiorec" = {
     format = "♬ Rec";
     format-disabled = "♬ Off-air"; # An empty format will hide the module.
     return-type = "json";
     interval = 1;
     exec = "echo '{\"class\": \"audio recording\"}'";
     exec-if = "pgrep ffmpeg";
};
     };
    };
    style = 
      ''
  *{
    font-family: Font Awesome;
    font-size: 18px;
    min-height: 0;
    color: white;
}

window#waybar {
    background-color: #1f1f1f;
}

#workspaces{
    margin-top: 3px;
    margin-bottom: 2px;
    margin-right: 10px;
    margin-left: 25px;
}

#workspaces button{
    border-radius: 15px;
    border: 1px solid #4c566a;
    margin-right: 10px;
    padding: 1px 10px;
    font-weight: bolder;
    background-color: #181818;
}

#workspaces button.active, #workspaces button.focused{
    padding: 0 22px;
    border: 1px solid #ffffff;
    box-shadow: rgba(6, 24, 44, 0.4) 0px 0px 0px 2px, rgba(6, 24, 44, 0.65) 0px 4px 6px -1px, rgba(255, 255, 255, 0.08) 0px 1px 0px inset;    
    background: #4682b4;
}
#workspaces button.urgent {
  background: #bf616a;
  color: #ffffff;
  border: 1px solid #ffffff;
  font-weight: bold;
}

#tray,
#mpd,
#cpu, 
#temperature, 
#memory,
#sway-mode,
#backlight, 
#pulseaudio,
#custom-recorder,
#custom-audiorec,
#battery, 
#clock, 
#network {
	padding: 0 10px;
        }
        '';
  };
}
