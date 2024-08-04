sudo apt update && sudo apt upgrade
sudo apt-get install build-essential
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt install cargo
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
solana-keygen new
##切换至主网
solana config set --url https://api.mainnet-beta.solana.com
cargo install ore-cli
export PATH="/root/.cargo/bin:$PATH"
##测试hash
ore benchmark --threads 4
