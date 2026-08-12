#!/bin/bash

target_file="/home/caste/.config/bin/target"
ip_address=$(awk '{print $1}' "$target_file")
machine_name=$(awk '{print $2}' "$target_file")

if [ -n "$ip_address" ] && [ -n "$machine_name" ]; then
  echo "<span foreground='#f7768e'>󰯐  $ip_address - $machine_name</span>"
else
  echo "<span foreground='#f7768e'>󰛑  No target</span>"
fi
