cd ~
#监控screen脚本
echo '#!/bin/bash
while true
do
    if ! screen -list | grep -q "ore"; then
        echo "Screen session not found, restarting..."
        start="ore --rpc $RPC_URL --keypair ~/.config/solana/id.json --priority-fee $PRIORITY_FEE mine --threads $THREADS"
        screen -dmS ore bash -c "$start"
    fi
    sleep 10  # 每隔10秒检查一次
done' > monit.sh
##给予执行权限
chmod +x monit.sh
# ================================================================================================================================
echo '[Unit]
Description=ore Monitor Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash /root/monit.sh

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/ore_monitor.service
sudo systemctl daemon-reload
sudo systemctl enable ore_monitor.service
sudo systemctl start ore_monitor.service
sudo systemctl status ore_monitor.service
