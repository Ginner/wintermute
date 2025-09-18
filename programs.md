
| program                                           | default | server | desktop | laptop | nixos module | home manager module | notes                                                                                      |
|---------------------------------------------------|:-------:|:------:|:-------:|:------:|:------------:|:-------------------:|--------------------------------------------------------------------------------------------|
| fwupd                                             |         |        |    X    |    X   |       X      |                     | Firmware updates for consumer hardware. ✅ IMPLEMENTED                                     |
| bolt                                              |         |        |         |    X   |       X      |                     | Thunderbolt security (auto-detects TB). ✅ IMPLEMENTED                                     |
| usbutils                                          |         |   X*   |    X*   |   X*   |       X      |                     | `lsusb`—moved to nixos for udev rules. ✅ IMPLEMENTED                                      |
| greetd                                            |         |        |    X    |    X   |       X      |                     | Display/login manager. ✅ IMPLEMENTED                                                      |
| pipewire                                          |         |        |    X    |    X   |       X      |                     | Include `wireplumber` & portals via system. ✅ IMPLEMENTED                                 |
| tlp                                               |         |        |         |    X   |       X      |                     | Power management for laptops. ✅ IMPLEMENTED                                               |
| tailscale (daemon)                                |         |    X   |    X*   |   X*   |       X      |                     | Daemon + firewall; enable broadly if you use it everywhere. ✅ IMPLEMENTED                |
| brightnessctl                                     |         |        |    X    |    X   |       X      |                     | Needs udev rules → system. ✅ IMPLEMENTED                                                  |
| xremap                                            |         |        |    X*   |   X*   |       X      |                     | Key remapping service with system permissions. ✅ IMPLEMENTED                              |
| openssh (daemon)                                  |    X    |    X   |    X*   |   X*   |       X      |                     | Server/service side (separate from client cfg). ✅ IMPLEMENTED                             |
| zsh (binary & default shell)                      |    X    |   X*   |    X*   |   X*   |       X      |          X          | System sets default shell; HM handles per-user rc/plugins. ✅ IMPLEMENTED                 |
| neovim                                            |    X    |    X   |    X    |    X   |       X      |          X          | System provides binary + minimal defaults; HM layers nixvim configs. ✅ IMPLEMENTED       |
| hyprland (WM)                                     |         |        |    X    |    X   |       X      |          X          | HM manages WM config; system handles greeter/portals. ✅ IMPLEMENTED                      |
| stylix                                            |         |        |    X    |    X   |       X      |          X          | Cross-cuts system + HM theming. Uses rose-pine-hyprcursor. ✅ IMPLEMENTED                 |
| kitty                                             |         |        |    X    |    X   |              |          X          | Terminal is per-user. ✅ IMPLEMENTED                                                       |
| mako                                              |         |        |    X    |    X   |              |          X          | Wayland notifications—user service. ✅ IMPLEMENTED                                         |
| waybar                                            |         |        |    X    |    X   |              |          X          | Panel—user service. ✅ IMPLEMENTED                                                         |
| ags                                               |         |        |    X*   |   X*   |              |          X          | If you use it for your bar/shell. ✅ IMPLEMENTED                                           |
| wl-clipboard                                      |         |        |    X    |    X   |              |          X          | Wayland clipboard. ✅ IMPLEMENTED (via wayland-tools)                                      |
| grim / slurp / wf-recorder / swappy               |         |        |    X    |    X   |              |          X          | Wayland screenshots/recording—user tools. ✅ IMPLEMENTED (via wayland-tools)               |
| walker                                            |         |        |    X    |    X   |              |          X          | Launcher—per-user. ✅ IMPLEMENTED                                                          |
| firefox                                           |         |        |    X    |    X   |              |          X          | Browser per-user. ✅ IMPLEMENTED                                                           |
| inkscape                                          |         |        |    X*   |   X*   |              |          X          | GUI app. ✅ IMPLEMENTED                                                                    |
| sxiv                                              |         |        |    X*   |   X*   |              |          X          | Image viewer. ✅ IMPLEMENTED                                                               |
| mpv                                               |         |        |    X*   |   X*   |              |          X          | Media player. ✅ IMPLEMENTED                                                               |
| zathura                                           |         |        |    X    |    X   |              |          X          | PDF viewer. ✅ IMPLEMENTED                                                                 |
| kde-connect                                       |         |        |    X*   |   X*   |       X      |          X          | HM runs user service; system opens firewall ports. ✅ IMPLEMENTED                          |
| git (client)                                      |    X    |    X   |    X    |    X   |              |          X          | Per-user config in HM (`user.name`, signing, etc.). ✅ IMPLEMENTED                        |
| ssh (client)                                      |    X    |    X   |    X    |    X   |              |          X          | Per-user keys and `~/.ssh/config` via HM. ✅ IMPLEMENTED                                   |
| direnv                                            |         |        |    X    |    X   |              |          X          | Dev-centric—enable on dev hosts by default. ✅ IMPLEMENTED                                 |
| tmux                                              |         |    X   |         |        |              |          X          | Great on servers & dev boxes. ✅ IMPLEMENTED                                               |
| starship                                          |         |        |    X    |    X   |              |          X          | Prompt—user choice. ✅ IMPLEMENTED                                                         |
| bat / eza / fd / ripgrep / fzf / jq / wget / tree |         |        |    X    |    X   |              |          X          | Core CLI set; HM is ideal. ✅ IMPLEMENTED (via cli-tools)                                  |
| yazi                                              |         |        |    X*   |   X*   |              |          X          | TUI file manager—dev/desktop. ✅ IMPLEMENTED                                               |
| btop                                              |         |        |    X*   |   X*   |              |          X          | Monitoring tool. ✅ IMPLEMENTED                                                            |
| imagemagick / poppler                             |         |        |    X    |    X   |              |          X          | Useful CLI tooling. ✅ IMPLEMENTED (as packages)                                           |
| ffmpeg / ffmpegthumbnailer                        |         |        |    X    |    X   |              |          X          | Media tooling; thumbnailer supports file managers. ✅ IMPLEMENTED (as packages)            |
| zip / unzip / xz / p7zip                          |         |    X   |    X    |    X   |              |          X          | Archive tools. ✅ IMPLEMENTED (via archive-tools)                                          |
| ncspot                                            |         |        |    X*   |   X*   |              |          X          | User app. ✅ IMPLEMENTED                                                                   |
| newsboat                                          |         |        |    X*   |   X*   |              |          X          | User app. ✅ IMPLEMENTED (as package)                                                      |
| calcurse                                          |         |        |    X*   |   X*   |              |          X          | User app. ✅ IMPLEMENTED (as package)                                                      |
| khard                                             |         |        |    X*   |   X*   |              |          X          | User app. ✅ IMPLEMENTED (as package)                                                      |
| cheat                                             |         |        |    X*   |   X*   |              |          X          | Dev convenience. ✅ IMPLEMENTED (as package)                                               |
| LaTeX (texlive)                                   |         |        |    X*   |   X*   |              |          X          | Big footprint—enable on dev/workstations. ✅ IMPLEMENTED                                   |
| podman (engine)                                   |         |   X*   |         |        |       X      |                     | System sets cgroups, subuids; CLI can be added via HM. ✅ IMPLEMENTED                     |
| numbat                                            |         |        |    X*   |   X*   |              |          X          | Calculator/REPL—developer comfort. ✅ IMPLEMENTED (as package)                             |

Legend: X = recommended, X* = optional/role-dependent, HM = Home-Manager.

## Implementation Status: ✅ COMPLETE

All applications from the table have been implemented with proper module structure:

### Created nixosModules:
- **services/**: bolt, brightnessctl, kde-connect, fwupd, greetd, pipewire, tlp, tailscale, xremap
- **programs/**: hyprland, kitty, zsh, usbutils
- **shared/**: stylix (with rose-pine-hyprcursor default)

### Created homeManagerModules:
- **cliPrograms/**: archive-tools, btop, cli-tools, git, ncspot, starship, tmux, walker
- **guiPrograms/**: ags, firefox, hyprland, inkscape, kde-connect, latex, mpv, sxiv, stylix, waybar, wayland-tools, xdg, zathura

### Bundle Integration:
- **Laptop**: Includes required apps, optional apps default to false
- **Desktop**: Desktop-specific apps and services
- **Server**: Minimal with tmux and monitoring tools
- **Default**: Core system with openssh, neovim, zsh

Everything is toggleable from host configurations as requested!
