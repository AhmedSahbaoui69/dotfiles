#!/usr/bin/env fish

# Get JSON cleanly (ignore sensor warnings)
set json (sensors -j 2>/dev/null)

# Extract any key that ends with "_input" under coretemp-isa-0000
set temps (echo $json | jq -r '
  .["coretemp-isa-0000"]
  | .. | objects
  | to_entries[]
  | select(.key | endswith("_input"))
  | .value
')

# Sum and count
set sum 0
set count 0
for t in $temps
    set sum (math "$sum + $t")
    set count (math "$count + 1")
end

if test $count -eq 0
    echo " (N/A)"
    exit 1
end

# Average
set avg (printf "%.0f" (math "$sum / $count"))

echo " $avg°C"

