#!/usr/bin/env bash

# Deployment parameters
warehouse_name=${1:-'xsmall'} # 'xsmall' or 'large'
schema_name=${2:-'adl_1000'}  # 'adl' or 'adl_1000'
runs_per_query=${3:-50}
warmups_per_query=${4:-10}

# Experiment parameters
database_name=${5:-'adl'}
generate_query_only=${6:-"yes"}   # can also be 'yes'
disable_result_cache=${7:-"yes"}  # can also be 'no'
disable_data_cache=${8:-"no"}     # can also be 'yes'

# Path parameters
SNOWFLAKE_CONFIGURATION_FILE=${8:-'/data/snowflake.properties'}
QUERY_PATHS=${9:-'/data/queries/multi_column'}
RUMBLE_PATH=${10:-'/data'}

# Rumble default JAR name
RUMBLE_JAR_NAME=${11:-'rumbledb-1.14.0-jar-with-dependencies.jar'}

# Copy the Snowflake config file and bring it locally
cd /data 
cp ${SNOWFLAKE_CONFIGURATION_FILE} ./snowflake.original.properties && \
sed "s/WAREHOUSENAME/$warehouse_name/" snowflake.original.properties \
| sed "s/DBNAME/$database_name/" \
| sed "s/SCHEMANAME/$schema_name/" \
> snowflake.updated.properties

# We now execute the experiments
EXPERIEMNT_NAME="RumbleDB_run_$(date +%F_%H_%M_%S_%3N)"
EXPERIMENT_FOLDER="experiments/${EXPERIEMNT_NAME}"
mkdir -p ${EXPERIMENT_FOLDER}

for query in q{1..8}; do
  mkdir -p ${EXPERIMENT_FOLDER}/${query}
  java -jar ${RUMBLE_JAR_NAME} \
      --show-error-info no \
      --print-iterator-tree no \
      --output-path temp.out \
      --snowflake-session-config snowflake.updated.properties \
      --exec-mode eval \
      --warehouse-name ${warehouse_name} \
      --disable-data-cache ${disable_data_cache} \
      --disable-result-cache ${disable_result_cache} \
      --experiment-id ${EXPERIEMNT_NAME} \
      --query-tag ${query} \
      --current-run-count "1" \
      --log-dump-file experiment.log.csv \
      --query-path ${QUERY_PATHS}/${query}/query.jq \
      --generate-query-only ${generate_query_only} \
      --warmups-per-query-generation-time ${warmups_per_query} \
      --runs-per-query-generation-time ${runs_per_query} \
  | tee ${EXPERIMENT_FOLDER}/${query}/run_${i}.log
done

# Finally we copy over the CSV with results to the experiment folder
mv experiment.log.csv ${EXPERIMENT_FOLDER}

# Echo the final status of the experiment
echo "NOTE: Experiment finished; the resulting logs are in `pwd`/${EXPERIMENT_FOLDER}"