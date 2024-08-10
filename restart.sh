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
echo "开始挖矿，会话名称为 $session_name ..."

# start="while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine; echo '进程异常退出，等待重启' >&2; sleep 1; done"
# screen -dmS "$session_name" bash -c "$start"
# # if sudo systemctl is-active --quiet ore_monitor.service; then
# #   # 服务正在运行
# #   pkill screen
# #   echo ''
# #   echo '监控服务正在运行'
# # else
# #   # 服务未运行
# #   cd ~
# #   pkill screen
# #   echo ''
# #   echo '监控服务未运行'
# #   #监控screen脚本
# #   echo '#!/bin/bash
# #   while true
# #   do
# #       if ! screen -list | grep -q "ore"; then
# #           echo "Screen session not found, restarting..."
# #           start="ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS"
# #           screen -dmS "ore" bash -c "$start"
# #       fi
# #       sleep 10  # 每隔10秒检查一次
# #   done' > monit.sh
# #   ##给予执行权限
# #   chmod +x monit.sh
#   # ================================================================================================================================
#   echo '[Unit]
#   Description=ore Monitor Service
#   After=network.target
  
#   [Service]
#   Type=simple
#   ExecStart=/bin/bash /root/monit.sh
  
#   [Install]
#   WantedBy=multi-user.target' > /etc/systemd/system/ore_monitor.service
#   sudo systemctl daemon-reload
#   sudo systemctl enable ore_monitor.service
#   sudo systemctl start ore_monitor.service
#   sudo systemctl status ore_monitor.service
# fi
# start="ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS"
# ==============================================
# # 检查ore命令是否存在
# if ! command -v ore &> /dev/null
# then
#     # 如果ore命令不存在，则安装rustup并设置环境变量
#     curl https://sh.rustup.rs -sSf | sh -s -- -y
#     source $HOME/.cargo/env
# else
#     # 如果ore命令存在，则输出1
#     echo "存在ore"
# fi
# ======================================================
# ==============================================
# 检查ore-cli是否存在
if [ ! -d "ore-cli" ]; then
    # 如果文件夹不存在，则执行git clone命令
    echo ''
    echo '文件夹不存在，执行git clone命令,下载低费率版本' 
    git clone -b jito https://github.com/a3165458/ore-cli.git 
    cd ore-cli
    cp ore /usr/bin
else
    # 如果文件夹存在，则输出1
    echo "1"
fi
# ==============================================

# start="while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS; echo '进程异常退出，等待重启' >&2; sleep 1; done"
start="while true; do ore mine --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE; echo '进程异常退出，等待重启' >&2; sleep 1; done"
export RUST_BACKTRACE=1
export RUST_BACKTRACE=full
screen -dmS "ore" bash -c "$start"
if screen -list | grep -q ore; then
    echo ''
    echo '重启完成'
else
    echo ''
    echo "重启失败"
fi
##删除此文件
cd ~
rm -f restart.sh
