#!/usr/bin/env bash

# Deployment parameters
warehouse_name=${1:-'large'} # 'xsmall' or 'large'
schema_name=${2:-'adl'}  # 'adl' or 'adl_1000'
database_name=${3:-'adl'}

# Experiment parameters
warmups_per_query=(0) # (3 1 1 1 1 1 1)
runs_per_query=(1) # (2 1 1 1 1 1 1)
disable_result_cache=${4:-"yes"} # can also be 'no'
disable_data_cache=${5:-"no"}    # can also be 'yes'

# Path parameters
QUERY_PATHS=${6:-'/home/dan/data/projects/java/rumbledb-snowflake/workloads/adl/queries/sql/implementations/multi_column'}

# Warmup parameters
RUN_WARMUP=${7:-"yes"}  # can also be 'no'

# We prepare the experiment folder and log
EXPERIEMNT_NAME="Snowflake_run_$(date +%F_%H_%M_%S_%3N)"
EXPERIMENT_FOLDER="experiments/${EXPERIEMNT_NAME}"
mkdir -p ${EXPERIMENT_FOLDER}

echo "dateTime,warehouseName,databaseName,schemaName,disableDataCache,disableResultCache,experimentID,queryTag,currentRunCount,queryGenerationTimeMean,queryGenerationTimeStd,\
  queryExecutionTime,snowflakeQueryID" > ${EXPERIMENT_FOLDER}/experiment.log.csv

# We now execute the experiments
idx=0
BASE_COMMAND="snowsql -c ${warehouse_name} -d ${database_name} -s ${schema_name}"
for query in q6; do
  # Create run folder and generate query text with appropriate cache disables and query id retrieval
  mkdir -p ${EXPERIMENT_FOLDER}/${query}
  QUERY_FILE=${EXPERIMENT_FOLDER}/${query}/query.sql

  if [ "${disable_data_cache}" = "yes" ]; then
    echo "ALTER WAREHOUSE ${warehouse_name} SUSPEND;" >> ${QUERY_FILE}
    echo "ALTER WAREHOUSE ${warehouse_name} RESUME IF SUSPENDED;" >> ${QUERY_FILE}
  fi

  if [ "${disable_result_cache}" = "yes" ]; then
    echo "ALTER SESSION SET USE_CACHED_RESULT = FALSE;" >> ${QUERY_FILE}
  fi

  cat ${QUERY_PATHS}/${query}/query.sql >> ${QUERY_FILE}

  echo "SELECT LAST_QUERY_ID();" >> ${QUERY_FILE}

  # Run the warmup
  if [ "${RUN_WARMUP}" = "yes" ]; then
    for i in $(seq 1 ${warmups_per_query[${idx}]}); do
      ${BASE_COMMAND} -f ${QUERY_FILE}
    done
  fi

  # Execute the query several times
  for i in $(seq 1 ${runs_per_query[${idx}]}); do
    ${BASE_COMMAND} -f ${QUERY_FILE} | tee ${EXPERIMENT_FOLDER}/${query}/run_${i}.log

    # Get the execution time (and convert from s to ms); also get the last query id
    execution_datetime=$( date +%F-%H-%M-%S )
    query_id=$( cat ${EXPERIMENT_FOLDER}/${query}/run_${i}.log | tail -n 4 | head -n 1 | awk '{print $2}' )
    
    exec_time=$( cat ${EXPERIMENT_FOLDER}/${query}/run_${i}.log | tail -n 8 | head -n 1 | awk '{print $6}' )
    exec_time=${exec_time%s}

    # Log this experiment to disk 
    echo "${execution_datetime},${warehouse_name},${database_name},${schema_name},${disable_data_cache},${disable_result_cache},\
      ${EXPERIEMNT_NAME},${query},${i},-1,-1,$( bc <<< "${exec_time} * 1000" ),${query_id}" >> ${EXPERIMENT_FOLDER}/experiment.log.csv
  done
  (( idx++ ))
done

# Echo the final status of the experiment
echo "NOTE: Experiment finished; the resulting logs are in `pwd`/${EXPERIMENT_FOLDER}"