{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      waybar = {
        layer = "top";
	output = "LVDS-1";
        position = "top";
        modules-left = [
          "custom/logo"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
	  "network"
          "disk"
          "memory"
          "cpu"
          "battery"
          "clock"
        ];
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
	    "1" = "󰲡";
	    "2" = "󰲣";
	    "3" = "󰲥";
	    "4" = "󰲧";
	    "5" = "󰲩";
	    "6" = "󰲫";
	    "7" = "󰲭";
	    "8" = "󰲯";
	    "9" = "󰲱";
	    "10" = "󰿭";
            "active" = "";
            "default" = "";
            "empty" = "";
          };
	  "sort-by" = "number";
	  "all-outputs" = true;
          # "persistent-workspaces" = {
          #   "*"= 10;
          # };
        };
        "clock" = {
          "format" = "{:%H:%M}";
          "format-alt" = "{:%Y.%m.%d %H:%M}";
	  "tooltip" = false;
        };
        "disk" = {
          "interval" = 60;
          "format" = "  {percentage_used}% ";
          "path" = "/";
        };
        "cpu" = {
          "interval" = 1;
          "format" = " {usage}% ";
          "min-length" = 6;
          "max-length" = 6;
        };
        "memory" = {
          "format" = " {percentage}% ";
        };
        "custom/logo" = {
          "format" = "";
          "tooltip" = false;
        };
        "network" = {
          "format-wifi" = "  ";
          "format-ethernet" = "  ";
          "format-disconnected" = "  ";
          "tooltip-format" = "{ipaddr}";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%)  | {ipaddr}";
          "tooltip-format-ethernet" = "{ifname} | {ipaddr}";
        };
        "battery"= {
          "interval"= 60;
          "states"= {
            "good"= 95;
            "warning"= 30;
            "critical"= 20;
          };
          "format"= "{icon} {capacity}% ";
          # "format-charging"= "{capacity}% 󰂄 ";
          "format-plugged"= "󰂄 {capacity}% ";
          # "format-alt"= "{time} {icon}";
          "format-icons"= [
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
          };
        };
      };
      style = ''
          * {
            border: none;
            font-size: 14px;
            font-family: JetBrainsMono Nerd Font,JetBrainsMono NF ;
            min-height: 25px;
	    color: white;
          }
          window#waybar {
            background: transparent;
            margin: 5px;
          }
          
          #custom-logo {
            padding: 0 10px;
          }

	  #workspaces button {
	    padding: 0 10px;
	    background-color: @surface0;
	    color: @text;
	  }
          
          .modules-right {
            padding-left: 15px;
            padding-right: 5px;
            border-radius: 15px 0 0 15px;
            margin-top: 2px;
            background: #000000;
          }
          
          .modules-center {
            padding: 0 5px 0 0px;
            margin-top: 2px;
            border-radius: 15px 15px 15px 15px;
            background: #000000;
          }
          
          .modules-left {
            border-radius: 0 15px 15px 0;
            margin-top: 2px;
	    padding-right: 10px;
            background: #000000;
          }

	  #clock {
	    padding: 5px 10px;
	  }
        '';
      };
}
