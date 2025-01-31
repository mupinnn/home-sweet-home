# Home Sweet Home

Home and development environment with Nix and home-manager to easily manage my machine(s).

## Setup

1. Install Nix https://nixos.org/download/#download-nix
2. Setup by cloning this repository

```sh
// with HTTP
git clone https://github.com/mupinnn/home-sweet-home.git ~/.config/home-manager

// with SSH
git clone git@github.com:mupinnn/home-sweet-home.git ~/.config/home-manager
```

3. Run `cd ~/.config/home-manager`
4. Run `home-manager build --flake .#mupin` and then run `home-manager build --flake .#mupin`
5. Setup `zsh` to be the default shell
   - `$ echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells`
   - `$ sudo usermod -s ~/.nix-profile/bin/zsh $USER`
6. Done!

## Usage

### Development Environment

See [./devShells.nix](`devShells.nix` definitions) to see the list of supported development environment.

- `nodejs${VERSION}` - Node.js environment with pnpm and bun.
- `ccpp` - C/C++ environment with `clang` and `gcc13` with the support of `cmake`, `make`, and `clang-tools`.

```console
nix develop ~/.config/home-manager#devShells.ccpp -c $SHELL
```

```console
nix develop ~/.config/home-manager#devShells.nodejs18 -c $SHELL
nix develop ~/.config/home-manager#devShells.nodejs20 -c $SHELL
```

## Acknowledgement

- [r17x/universe](https://github.com/r17x/universe) - for entire setup inspiration
- [Yumasi/nixos-home](https://github.com/Yumasi/nixos-home/blob/main/zsh.nix) - zsh setup
- [vimjoyer/nvim-nix-video](https://github.com/vimjoyer/nvim-nix-video/) - nice nix and nvim configuration introduction
- [nusendra/nix-home](https://github.com/nusendra/nix-home/blob/master/devShells.nix) - `devShells` inspiration
- [jeffkreeftmeijer/devshells](https://github.com/jeffkreeftmeijer/devshells) - `devShells` inspiration
- [DeterminateSystems/zero-to-nix](https://github.com/DeterminateSystems/zero-to-nix/blob/main/nix/templates/dev/javascript/flake.nix) - `devShells` inspiration

## Resources

- https://ayats.org/blog/nix-workflow
- https://jeffkreeftmeijer.com/nix-devshells/
- https://mtlynch.io/notes/nix-dev-environment/
- https://nixos-and-flakes.thiscute.world/development/intro
- https://github.com/the-nix-way/dev-templates
- https://zero-to-nix.com/start/nix-develop/
