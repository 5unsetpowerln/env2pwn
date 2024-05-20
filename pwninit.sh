#!/usr/bin/env bash

file=$(pwd)

cd ~/Tools/env2pwn/

rm -rf ./programs.bak/
mv ./programs ./programs.bak
cp -r $file ./programs

cp -r $HOME/.config/nvim ./
cp $HOME/.ssh/id_ed25519.pub ./

docker compose up -d --build

./manage_aslr.sh n

docker compose exec pwn /bin/fish
