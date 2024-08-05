sudo apt-get update
sudo apt install git
git clone https://github.com/hardhatchad/ore
git clone https://github.com/hardhatchad/ore-cli
git clone https://github.com/hardhatchad/drillx
cd ore && git checkout master && cd ..
cd ore-cli && git checkout master && cd ..

cd ore-cli
export http=http://c38562:52488@47.90.169.195:16801
cargo build --release
cd target/release
./ore mine --keypair ~/.config/solana/id.json --threads 8 --rpc https://api.devnet.solana.com
