#!/bin/bash

input=$(sudo __vpn_manager status)
output=$(echo "$input" | sed -E 's/^(Connected|Disconnected) .* \(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+\)/\1 (\2)/')
echo "$output"

