# DynECC ASIC - Open Source Flow

## How to execute 🔥
Since the flow is completely open source, you can run it on your machine and generate the chip's production files, as well as metrics and visualizations. You only need to install [Nix](https://nix.dev) package manager to use the nix shell, which is responsible for handling Librelane versions and their packages.
To install nix shell run:
 - On Linux:
```curl -L https://nixos.org/nix/install | sh -s -- --daemon```
  - On MacOS:
```curl -L https://nixos.org/nix/install | sh```
  - On Windows (WSL2):
```curl -L https://nixos.org/nix/install | sh -s -- --no-daemon```

After installing the nix shell, run the following command (you need to have a x86-linux terminal) inside the project folder to download librelane and its packages:
```$ nix --extra-experimental-features 'nix-command flakes' develop```

Once you have executed the commands without errors, you can run librelane inside the nix shell to synthesize the chip:

```$ librelane --pdk ihp-sg13g2 config.yaml```

The process may take a while, but it should run without any errors. After that you can view the GDSII file of the chip in KLayout:

```$ librelane --pdk ihp-sg13g2 --last-run --flow openinklayout config.yaml```
