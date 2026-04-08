{ config, pkgs, lib, ... }:

let
  cfg = config.myHomeModules.tuiPrograms.tmux;
in
{
  options.myHomeModules.tuiPrograms.tmux = {
    enable = lib.mkEnableOption "Terminal multiplexer with sensible defaults";

    enableVim = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable vim-style key bindings";
    };

    enableMouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable mouse support";
    };

    historyLimit = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      description = "Scrollback history limit";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      mouse = cfg.enableMouse;
      historyLimit = cfg.historyLimit;

      extraConfig = lib.optionalString cfg.enableVim ''
        # Vim-style key bindings
        setw -g mode-keys vi
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Better split commands
        bind | split-window -h
        bind - split-window -v

        # Quick reload
        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      '';
    };
  };
}
