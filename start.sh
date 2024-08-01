# curl https://sh.rustup.rs -sSf | sh
# sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
# source "$HOME/.cargo/env"
# export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
# solana-keygen new -o /root/.config/solana/id.json
# solana config set --url d

# sudo apt update
# sudo apt install build-essential

# # git clone https://github.com/regolith-labs/ore-cli.git
# # cd ore-cli/
# # cargo build --release
# cargo install ore-cli@1.0.0-alpha.6 #将会安装测试网v2版本

# export RUST_BACKTRACE=1
# export RUST_BACKTRACE=full

# # sudo ln -s /root/ore-cli/target/release/ore /usr/local/bin/ore
# sudo ln -s /root/.cargo/bin/ore /usr/local/bin/ore
# export PATH=$PATH:/usr/local/bin
# source ~/.bashrc

#要回车
curl --proto '=https" --tlsv1.3 https://sh.rustup.rs -sSf | sh
source "$HOME/.cargo/env"
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
#要回车
solana-keygen new -o /root/.config/solana/id.json
solana config set --url d

sudo apt update
#要输入y 出现额外弹窗
sudo apt install build-essential

export RUST_BACKTRACE=1
export RUST_BACKTRACE=full

mkdir extend-stats
cd extend-stats/
git clone -b extended_stats --single-branch https://github.com/pmcochrane/ore-cli.git
cd ore-cli/
./build_and_mine.sh 
cp ore_env.priv.sh.sample ore_env.priv.sh
