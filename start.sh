echo "\$nrconf{kernelhints} = 0;" >> /etc/needrestart/needrestart.conf
echo "\$nrconf{restart} = 'l';" >> /etc/needrestart/needrestart.conf
sudo apt update -y
sudo apt-get install build-essential -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path > /dev/null 2>&1
# . "$HOME/.cargo/env"
sudo apt install cargo -y
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
solana-keygen new --no-bip39-passphrase --force
##切换至主网
solana config set --url https://api.mainnet-beta.solana.com
cargo install ore-cli
export PATH="/root/.cargo/bin:$PATH"
##测试hash
ore benchmark --threads 4
