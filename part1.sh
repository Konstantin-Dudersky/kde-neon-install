 #!/usr/bin/bash

# install rust
sudo apt install build-essential pkg-config cmake libssl-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"

# install nushell
cargo install nu
