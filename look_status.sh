#!/bin/bash

if screen -list | grep -q ore; then
    echo "运行中"
else
    echo "停止"
fi
