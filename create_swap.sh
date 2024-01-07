#!/bin/bash

if [ -e /swapfile ]; then
    echo "Swap file already exists."
    exit 1
fi

swap_size_mb=$1

sudo fallocate -l ${swap_size_mb}M /swapfile

sudo chmod 600 /swapfile

sudo mkswap /swapfile

sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Swap file of ${swap_size_mb}MB created successfully."

sudo swapon --show
