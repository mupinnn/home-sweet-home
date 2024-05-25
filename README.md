# Home Sweet Home

Home environment with Nix and home-manager to easily manage my machine(s).

## Usage

1. Install Nix https://nixos.org/download/#download-nix
2. Install `home-manager` https://nix-community.github.io/home-manager/index.xhtml#ch-installation
3. Setup by cloning this repository

```sh
// with HTTP
git clone https://github.com/mupinnn/home-sweet-home.git ~/.config/home-manager

// with SSH
git clone git@github.com:mupinnn/home-sweet-home.git ~/.config/home-manager
```

4. Run `home-manager switch`
5. Setup `zsh` to be the default shell
   - `$ echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells`
   - `$ sudo usermod -s ~/.nix-profile/bin/zsh $USER`
6. Done!

## Acknowledgement

- [r17x - nixpkgs](https://github.com/r17x/nixpkgs)
- [Yumasi - nixos-home](https://github.com/Yumasi/nixos-home/blob/main/zsh.nix)
- [vimjoyer - nvim-nix-video](https://github.com/vimjoyer/nvim-nix-video/)
- [josean-dev - dev-environment-files](https://github.com/josean-dev/dev-environment-files)

## TODO

- [ ] Bash script to generate public key from copied ssh private key
- [ ] Neovim
  - [x] Formatter
  - [x] Linter
  - [x] Code action
  - [ ] Copilot
- [ ] Multiple git user
