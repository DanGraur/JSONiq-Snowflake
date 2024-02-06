#!/usr/bin/env bash

# Deployment parameters
system_type=${1:-'snowflake'}  # 'snowflake' or rumbledb
warehouse_name=${2:-'large'} # 'xsmall' or 'large'
database_name=${3:-'adl'}

# Experiment parameters
disable_result_cache=${4:-"yes"} # can also be 'no'
disable_data_cache=${5:-"no"}    # can also be 'yes'

RUMBLEDB_SCRIPT_PATH="/home/dan/data/projects/java/rumbledb-snowflake/workloads/adl/experiment-scripts/evaluate-rumbledb-queries.sh"
SNOWFLAKE_SCRIPT_PATH="/home/dan/data/projects/java/rumbledb-snowflake/workloads/adl/experiment-scripts/evaluate-snowflake-queries.sh"

# Create the schema names we will go over
scales="$( for i in {0..15}; do echo adl_$((2**$i*1000)); done) adl $( for i in {1..6}; do echo adl_sf$((2**$i)); done)"

# Create an experiment path
EXPERIMENT_FOLDER="experiments/${system_type}_sweep_run_$(date +%F_%H_%M_%S_%3N)"
mkdir -p ${EXPERIMENT_FOLDER}

if [ "${system_type}" = "snowflake" ]; then
  for i in ${scales}; do 
    # Schedule a run at a given scale
    ${SNOWFLAKE_SCRIPT_PATH} \
      ${warehouse_name} \
      ${i} \
      ${database_name} \
      ${disable_result_cache} \
      ${disable_data_cache} \
      | tee -a ${EXPERIMENT_FOLDER}/console.log

     # Find where the results have been stored and copy the data over
    run_path=$( cat ${EXPERIMENT_FOLDER}/console.log | tail -n 1 | awk '{print $9;}')
    mkdir -p ${EXPERIMENT_FOLDER}/${i} && cp -r ${run_path}/* ${EXPERIMENT_FOLDER}/${i}
  done
elif [ "${system_type}" = "rumbledb" ]; then
  for i in ${scales}; do 
    # Determine whether RumbleDB needs to be rebuilt
    if [ "${i}" = "adl_1000" ] || [ "${i}" = "adl_sf2" ]; then
      rebuild="yes"
    else
      rebuild="no"
    fi 

    # Schedule a run at a given scale
    ${RUMBLEDB_SCRIPT_PATH} \
      ${warehouse_name} \
      ${i} \
      ${database_name} \
      "no" \
      ${disable_result_cache} \
      ${disable_data_cache} \
      ${rebuild} \
      | tee -a ${EXPERIMENT_FOLDER}/console.log

    # Find where the results have been stored and copy the data over
    run_path=$( cat ${EXPERIMENT_FOLDER}/console.log | tail -n 1 | awk '{print $9;}')
    mkdir -p ${EXPERIMENT_FOLDER}/${i} && cp -r ${run_path}/* ${EXPERIMENT_FOLDER}/${i}
  done
else
  echo "Chosen system ${system_type} is not supported!"
fi 

# Bring the individual experiment logs into one place and concatenate the summary
for p in $( ls ${EXPERIMENT_FOLDER} ); do
  if [ -d "${EXPERIMENT_FOLDER}/${p}" ]; then
    if [ -f "${EXPERIMENT_FOLDER}/experiment.log.csv" ]; then
      cat ${EXPERIMENT_FOLDER}/${p}/experiment.log.csv | tail -n +2 >> ${EXPERIMENT_FOLDER}/experiment.log.csv
    else 
      cp ${EXPERIMENT_FOLDER}/${p}/experiment.log.csv ${EXPERIMENT_FOLDER}
    fi
  fi
done

# Report the final results as being done
echo "NOTE: Experiment finished; the resulting logs are in `pwd`/${EXPERIMENT_FOLDER}"