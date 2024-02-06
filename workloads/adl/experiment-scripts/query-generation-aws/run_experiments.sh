#!/usr/bin/env bash

warehouse_name=${1:-'xsmall'} # 'xsmall' or 'large'
schema_name=${2:-'adl_1000'}  # 'adl' or 'adl_1000'
runs_per_query=${3:-100}

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

. "$SCRIPT_PATH/ec2-helpers.sh"

# Get the name of the instance
experiments_dir="$SCRIPT_PATH/experiments"
deploy_dir=${experiments_dir}/$(discover_cluster "$experiments_dir")
dnsname=($(discover_dnsnames "$deploy_dir"))

# Execute the experiment
current_date=$(date +%F_%H_%M_%S)
ssh -q ec2-user@${dnsname[0]} "cd /data && ./evaluate-snowflake-query-generation.sh ${warehouse_name} ${schema_name} ${runs_per_query}"
ssh -q ec2-user@${dnsname[0]} \
                    <<-'EOF'
        cd /data
        last_exp_name=$( ls experiments | sort | tail -n 1 )
        zip -FSr results.zip experiments/$last_exp_name
EOF

# Copy the results over
scp ec2-user@${dnsname[0]}:/data/results.zip ${deploy_dir}/results.zip && unzip ${deploy_dir}/results.zip -d ${deploy_dir}
echo "Results are available as: " 
echo " > An archive: ${deploy_dir}/results.zip" 
echo " > Raw files: ${deploy_dir}/results/experiments/$( ls ${deploy_dir}/results/experiments | tail -n 1 )" 

# Try and plot the results
python plot.py \
  --summary_path=${deploy_dir}/results/experiments/$( ls ${deploy_dir}/results/experiments | tail -n 1 )/experiment.log.csv \
  --plot_type=generation-time \
  --output_path=`pwd` && echo "Was also able to plot the results: `pwd`!"
