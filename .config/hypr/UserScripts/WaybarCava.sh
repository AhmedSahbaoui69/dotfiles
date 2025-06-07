#!/bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g"
for ((i = 0; i < ${#bar}; i++)); do
  dict+=";s/$i/${bar:$i:1}/g"
done

# Create cava config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Kill cava if it's already running
pkill -f "cava -p $config_file"

# Read stdout from cava and perform substitution in a single sed command
cava -p "$config_file" | sed -u "$dict"
