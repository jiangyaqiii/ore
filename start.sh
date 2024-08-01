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
chmod +x ore_env.priv.sh

ORE_DIR="$HOME/extend-stats/ore-cli"
ORE_FILE="$ORE_DIR/ore_env.priv.sh"
read -p "请输入sol的rpc(回车即使用默认开发网rpc): " rpc
rpc=${rpc:-"https://api.devnet.solana.com"}

# 更新 solxen-tx.yaml 文件
sed -i "s|KEY1=.*|KEY1=\~/.config/solana/id.json\|" $ORE_FILE
sed -i "s|RPC1=.*|RPC1=$rpc|" $ORE_FILE

./miner.sh 1



