#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

echo "\$nrconf{kernelhints} = 0;" >> /etc/needrestart/needrestart.conf
echo "\$nrconf{restart} = 'l';" >> /etc/needrestart/needrestart.conf

# 更新系统和安装必要的包
echo "更新系统软件包..."
sudo apt update -y
echo "安装必要的工具和依赖..."
sudo apt install -y curl build-essential jq git libssl-dev pkg-config screen

# 安装 Rust 和 Cargo
echo "正在安装 Rust 和 Cargo..."
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

# 安装 Solana CLI
echo "正在安装 Solana CLI..."
sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"

# 检查 solana-keygen 是否在 PATH 中
if ! command -v solana-keygen &> /dev/null; then
    echo "将 Solana CLI 添加到 PATH"
    export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "正在恢复Solana钱包..."
# 提示用户输入助记词
echo "下方请粘贴/输入你的助记词，用空格分隔，盲文不会显示的"
#read -p "请输入solana钱包的助记词: " seed_phrases

# 使用助记词恢复钱包
echo "$seed_phrases" > /root/.config/solana/id.json

echo "钱包已恢复。"
echo "请确保你的钱包地址已经充足的 SOL 用于交易费用。"

# 安装 Ore CLI
echo "正在安装 Ore CLI..."
cargo install ore-cli

# 检查并将Solana的路径添加到 .bashrc，如果它还没有被添加
grep -qxF 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# 检查并将Cargo的路径添加到 .bashrc，如果它还没有被添加
grep -qxF 'export PATH="$HOME/.cargo/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

# 使改动生效
source ~/.bashrc

# 获取用户输入的 RPC 地址或使用默认地址
#read -p "请输入自定义的 RPC 地址，建议使用免费的Quicknode 或者alchemy SOL rpc(默认设置使用 https://api.mainnet-beta.solana.com): " custom_rpc
RPC_URL=${custom_rpc:-https://api.mainnet-beta.solana.com}

# 获取用户输入的线程数或使用默认值
#read -p "请输入挖矿时要使用的线程数 (默认设置 1): " custom_threads
THREADS=${custom_threads:-1}

# 获取用户输入的优先费用或使用默认值
#read -p "请输入交易的优先费用 (默认设置 1): " custom_priority_fee
PRIORITY_FEE=${custom_priority_fee:-1}

# 使用 screen 和 Ore CLI 开始挖矿
export RUST_BACKTRACE=1
export RUST_BACKTRACE=full
session_name="ore"
echo "开始挖矿，会话名称为 $session_name ..."

start="while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS; echo '进程异常退出，等待重启' >&2; sleep 1; done"
screen -dmS "$session_name" bash -c "$start"

# # ===================================公共模块===监控screen模块======================================================================
# cd ~
# #监控screen脚本
# echo '#!/bin/bash
# while true
# do
#     if ! screen -list | grep -q "ore"; then
#         echo "Screen session not found, restarting..."
#         # 使用 screen 和 Ore CLI 开始挖矿
#         session_name="ore"
#         echo "开始挖矿，会话名称为 $session_name ..."

#         start="while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS; echo '进程异常退出，等待重启' >&2; sleep 1; done"
#         screen -dmS "$session_name" bash -c "$start"
#     fi
#     sleep 10  # 每隔10秒检查一次
# done' > monit.sh
# ##给予执行权限
# chmod +x monit.sh
# # ================================================================================================================================
# echo '[Unit]
# Description=Ore Monitor Service
# After=network.target

# [Service]
# Type=simple
# ExecStart=/bin/bash /root/monit.sh

# [Install]
# WantedBy=multi-user.target' > /etc/systemd/system/ore_monitor.service
# sudo systemctl daemon-reload
# sudo systemctl enable ore_monitor.service
# sudo systemctl start ore_monitor.service
# sudo systemctl status ore_monitor.service

echo "挖矿进程已在名为 $session_name 的 screen 会话中后台启动。"
echo "使用 'screen -r $session_name' 命令重新连接到此会话。"

