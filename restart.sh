#------------------------停止上一个会话------------------------
pkill screen
echo ''
echo '已停止上一会话'

echo "正在恢复Solana钱包..."
# 提示用户输入助记词
echo "下方请粘贴/输入你的助记词，用空格分隔，盲文不会显示的"
#read -p "请输入solana钱包的助记词: " seed_phrases

# 使用助记词恢复钱包
# 检查seed_phrases是否有值
if [ -n "$seed_phrases" ]; then
    echo "$seed_phrases"
    echo " "
    echo "$seed_phrases" > /root/.config/solana/id.json
    echo "钱包已恢复。"
fi
echo "请确保你的钱包地址已经充足的 SOL 用于交易费用。"

#------------------------启动服务------------------------
# 获取用户输入的 RPC 地址或使用默认地址
#read -p "请输入自定义的 RPC 地址，建议使用免费的Quicknode 或者alchemy SOL rpc(默认设置使用 https://api.mainnet-beta.solana.com): " custom_rpc

# RPC_URL=${custom_rpc:-https://api.mainnet-beta.solana.com}
RPC_URL=${custom_rpc:-https://node.onekey.so/sol}
echo "$RPC_URL"
echo " "
THREADS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
echo "$THREADS"
echo " "
# 获取用户输入的优先费用或使用默认值
#read -p "请输入交易的优先费用 (默认设置 1): " custom_priority_fee
PRIORITY_FEE=${custom_priority_fee:-1}
echo "$PRIORITY_FEE"
echo " "
# # 使用 screen 和 Ore CLI 开始挖矿
session_name="ore"
# ==============================================
# # 检查ore命令是否存在
if ! command -v ore &> /dev/null
then
    # 如果ore命令不存在，则安装rustup并设置环境变量
    echo ' '
    echo "ore命令不存在，安装rustup并设置环境变量"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    cargo install ore-cli
else
    # 如果ore命令存在，则输出1
    echo ' '
    echo "存在ore命令"
fi
source $HOME/.cargo/env
# ======================================================
# ==============================================
# 检查ore-cli是否存在
# if [ ! -d "ore-cli" ]; then
#     # 如果文件夹不存在，则执行git clone命令
#     echo ''
#     echo '文件夹不存在，执行git clone命令,下载低费率版本' 
#     git clone -b jito https://github.com/a3165458/ore-cli.git 
#     cd ore-cli
#     cp ore /usr/bin
# else
#     # 如果文件夹存在，则输出1
#     echo "1"
# fi
# ==============================================

start="while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine; echo '进程异常退出，等待重启' >&2; sleep 1; done"
export RUST_BACKTRACE=1
export RUST_BACKTRACE=full
screen -dmS "ore" bash -c "$start"
if screen -list | grep -q ore; then
    echo ''
    echo '重启完成'
    echo "开始挖矿，会话名称为 $session_name ..."
else
    echo ''
    echo "重启失败"
fi
##删除此文件
cd ~
rm -f restart.sh
