
| program                                           | default | server | desktop | laptop | nixos module | home manager module | notes                                                                                      |
|---------------------------------------------------|:-------:|:------:|:-------:|:------:|:------------:|:-------------------:|--------------------------------------------------------------------------------------------|
| fwupd                                             |         |        |    X    |    X   |       X      |                     | Firmware updates for consumer hardware.                                                    |
| bolt                                              |         |        |         |    X   |       X      |                     | Thunderbolt security (only if TB present).                                                 |
| usbutils                                          |         |   X*   |    X*   |   X*   |              |          X          | `lsusb`—handy everywhere, HM is fine.                                                      |
| greetd                                            |         |        |    X    |    X   |       X      |                     | Display/login manager.                                                                     |
| pipewire                                          |         |        |    X    |    X   |       X      |                     | Include `wireplumber` & portals via system.                                                |
| tlp                                               |         |        |         |    X   |       X      |                     | Power management for laptops.                                                              |
| tailscale (daemon)                                |         |    X   |    X*   |   X*   |       X      |                     | Daemon + firewall; enable broadly if you use it everywhere.                                |
| brightnessctl                                     |         |        |    X    |    X   |       X      |                     | Needs udev rules → system.                                                                 |
| openssh (daemon)                                  |    X    |    X   |    X*   |   X*   |       X      |                     | Server/service side (separate from client cfg).                                            |
| zsh (binary & default shell)                      |    X*   |   X*   |    X*   |   X*   |      X*      |          X          | System sets default shell; HM handles per-user rc/plugins.                                 |
| neovim                                            |    X    |    X   |    X    |    X   |       X      |          X          | System provides binary + minimal defaults (server); HM layers configs; manage with nixvim? |
| hyprland (WM)                                     |         |        |    X    |    X   |      X*      |          X          | HM manages WM config; system handles greeter/portals.                                      |
| stylix                                            |         |        |    X    |    X   |       X      |          X          | Cross-cuts system + HM theming.                                                            |
| kitty                                             |         |        |    X    |    X   |              |          X          | Terminal is per-user.                                                                      |
| mako                                              |         |        |    X    |    X   |              |          X          | Wayland notifications—user service.                                                        |
| waybar                                            |         |        |    X    |    X   |              |          X          | Panel—user service.                                                                        |
| ags                                               |         |        |    X*   |   X*   |              |          X          | If you use it for your bar/shell.                                                          |
| wl-clipboard                                      |         |        |    X    |    X   |              |          X          | Wayland clipboard.                                                                         |
| grim / slurp / wf-recorder / swappy               |         |        |    X    |    X   |              |          X          | Wayland screenshots/recording—user tools.                                                  |
| walker                                            |         |        |    X    |    X   |              |          X          | Launcher—per-user.                                                                         |
| Firefox                                           |         |        |    X    |    X   |              |          X          | Browser per-user.                                                                          |
| Inkscape                                          |         |        |    X*   |   X*   |              |          X          | GUI app.                                                                                   |
| sxiv                                              |         |        |    X*   |   X*   |              |          X          | Image viewer.                                                                              |
| mpv                                               |         |        |    X*   |   X*   |              |          X          | Media player.                                                                              |
| zathura                                           |         |        |    X    |    X   |              |          X          | PDF viewer.                                                                                |
| kde-connect                                       |         |        |    X*   |   X*   |      X*      |          X          | HM runs user service; system can open firewall ports.                                      |
| git (client)                                      |    X    |    X   |    X    |    X   |              |          X          | Per-user config in HM (`user.name`, signing, etc.).                                        |
| ssh (client)                                      |    X    |    X   |    X    |    X   |              |          X          | Per-user keys and `~/.ssh/config` via HM.                                                  |
| direnv                                            |         |        |    X    |    X   |              |          X          | Dev-centric—enable on dev hosts by default.                                                |
| tmux                                              |         |    X   |         |        |              |          X          | Great on servers & dev boxes.                                                              |
| starship                                          |         |        |    X    |    X   |              |          X          | Prompt—user choice.                                                                        |
| bat / eza / fd / ripgrep / fzf / jq / wget / tree |         |        |    X    |    X   |              |          X          | Core CLI set; HM is ideal; sprinkle on servers as needed.                                  |
| yazi                                              |         |        |    X*   |   X*   |              |          X          | TUI file manager—dev/desktop.                                                              |
| btop                                              |         |        |    X*   |   X*   |              |          X          | Monitoring tool.                                                                           |
| imagemagick / poppler                             |         |        |    X    |    X   |              |          X          | Useful CLI tooling.                                                                        |
| ffmpeg / ffmpegthumbnailer                        |         |        |    X    |    X   |              |          X          | Media tooling; thumbnailer supports file managers.                                         |
| zip / unzip / xz / p7zip                          |         |    X   |    X    |    X   |              |          X          | Archive tools.                                                                             |
| ncspot                                            |         |        |    X*   |   X*   |              |          X          | User app.                                                                                  |
| newsboat                                          |         |        |    X*   |   X*   |              |          X          | User app.                                                                                  |
| calcurse                                          |         |        |    X*   |   X*   |              |          X          | User app.                                                                                  |
| khard                                             |         |        |    X*   |   X*   |              |          X          | User app.                                                                                  |
| cheat                                             |         |        |    X*   |   X*   |              |          X          | Dev convenience.                                                                           |
| LaTeX (texlive)                                   |         |        |    X*   |   X*   |              |          X          | Big footprint—enable on dev/workstations.                                                  |
| podman (engine)                                   |         |   X*   |         |        |       X      |                     | System sets cgroups, subuids; CLI can be added via HM.                                     |
| numbat                                            |         |        |    X*   |   X*   |              |          X          | Calculator/REPL—developer comfort.                                                         |

Legend: X = recommended, X* = optional/role-dependent, HM = Home-Manager.

I've created the following table for my own convenience. It lays out my plan for the placement of applications and the
  configuration, etc. I'd love your help configuring my setup with the listed application

| pass-wayland |  |  | X* | X* |  | X | With HM you can also run user gpg-agent. |
