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
echo 'y'| ore --rpc https://api.mainnet-beta.solana.com  --keypair ~/.config/solana/id.json --priority-fee 100000 claim
