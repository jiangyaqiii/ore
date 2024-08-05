#------------------------停止上一个会话------------------------
screen -X -S ore quit
echo ''
echo '已停止上一会话'

#------------------------启动服务------------------------
# 使用 screen 和 Ore CLI 开始挖矿
session_name="ore"
echo "开始挖矿，会话名称为 $session_name ..."

start="while true; do ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS; echo '进程异常退出，等待重启' >&2; sleep 1; done"
screen -dmS "$session_name" bash -c "$start"

echo ''
echo '重启完成'
##删除此文件
cd ~
rm -f restart.sh
