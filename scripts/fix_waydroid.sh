#!/bin/bash

waydroid session stop
sudo firewall-cmd --zone=trusted --add-interface=waydroid0 --permanent
sudo iptables -P FORWARD ACCEPT
sleep 2
