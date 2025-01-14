# NixOS config
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run nixpkgs#git -- clone https://github.com/erogemaster225/yuki ~/nix-config
nix run home-manager/master -- switch --flake .#sakurafrost225
 ```