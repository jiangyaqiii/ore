#------------------------停止上一个会话------------------------
screen -X -S ore quit
echo ''
echo '已停止上一会话'

echo "正在恢复Solana钱包..."
# 提示用户输入助记词
echo "下方请粘贴/输入你的助记词，用空格分隔，盲文不会显示的"
#read -p "请输入solana钱包的助记词: " seed_phrases

# 使用助记词恢复钱包
echo "$seed_phrases" > /root/.config/solana/id.json

echo "钱包已恢复。"
echo "请确保你的钱包地址已经充足的 SOL 用于交易费用。"

#------------------------启动服务------------------------
# 获取用户输入的 RPC 地址或使用默认地址
#read -p "请输入自定义的 RPC 地址，建议使用免费的Quicknode 或者alchemy SOL rpc(默认设置使用 https://api.mainnet-beta.solana.com): " custom_rpc
RPC_URL=${custom_rpc:-https://api.mainnet-beta.solana.com}

THREADS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# 获取用户输入的优先费用或使用默认值
#read -p "请输入交易的优先费用 (默认设置 1): " custom_priority_fee
PRIORITY_FEE=${custom_priority_fee:-1}

# 使用 screen 和 Ore CLI 开始挖矿
session_name="ore"
echo "开始挖矿，会话名称为 $session_name ..."

start="source $HOME/.cargo/env while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS; echo '进程异常退出，等待重启' >&2; sleep 1; done"
screen -dmS "$session_name" bash -c "$start"

echo ''
echo '重启完成'
##删除此文件
cd ~
rm -f restart.sh
