#!/usr/bin/env bash

cd ~/Tools/env2pwn/
docker compose kill pwn
./manage_aslr.sh y
