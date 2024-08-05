git clone https://github.com/hardhatchad/ore
git clone https://github.com/hardhatchad/ore-cli
git clone https://github.com/hardhatchad/drillx
cd ore && git checkout master && cd ..
cd ore-cli && git checkout master && cd ..

cd ore-cli
cargo build --release
cd target/release
./ore mine --keypair ~/.config/solana/id.json --threads 8 --rpc https://api.devnet.solana.com
