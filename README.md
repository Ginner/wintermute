# LT·HL OS

## Laptop module
Dock fix: `boltctl list` -> `boltctl enroll <device-id>`

## Default module
The user is set, you need to set a password for the user with `passwd <username>`(_I'm not sure how this works in my setup..._).

## TODO
- [ ] agenix
- [ ] Neomutt
- [ ] Calcurse
- [ ] direnv
- [ ] LaTeX
- [ ] [cheat](https://github.com/cheat/cheat)/[cheat.sh](https://github.com/chubin/cheat.sh)/[navi](https://github.com/denisidoro/navi)?
- [ ] Combine desktop/Laptop - The only differences are tlp, I think. Maybe it could just be handled as a 'small' toggle...
- [ ] Add host-options: VM, wsl, 
- [ ] preconfigure pinentry for rbw (`pinentry-tty`)

## Pre-build
### agenix

## Post build

### rbw
_Bitwarden commandline client_

After build, `rbw` is configured using the following commands:
`rbw config set email <user-email>`

