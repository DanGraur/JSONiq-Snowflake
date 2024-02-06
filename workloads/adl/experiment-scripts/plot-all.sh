#!/usr/bin/env bash

summary_path=${1:-"summary.log.csv"}
save_path=${2:-"plots"}

mkdir -p ${save_path}

# for i in 'execution-time' 'compilation-time' 'bytes-scanned' 'credits-used' 'total-time-full' "bytes-local-spill" "bytes-remote-spill" "bytes-sent-over-network" "partition-scan-fraction"; do
for i in 'compilation-time'; do
  python plot.py --plot_type=${i} --summary_paths=${summary_path} --output_path=${save_path}
  if [ "$?" -eq "0" ]; then
    echo "Finished the ${i} plot!"
  else
    echo "Could not generate the ${i} plot!"
  fi
done

echo "Done plotting data; plots located in: ${save_path}" 