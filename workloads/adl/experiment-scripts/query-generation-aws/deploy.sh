#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Get the parameters
INSTANCE_TYPE=${1:-"m5d.xlarge"}

# Path parameters
SNOWFLAKE_CONFIGURATION_FILE=${2:-'/home/dan/data/projects/java/rumbledb-snowflake/workloads/adl/experiment-scripts/snowflake.properties'}
QUERY_PATHS=${3:-'/home/dan/data/projects/java/rumbledb-snowflake/workloads/adl/queries/jsoniq/implementations/multi_column'}
RUMBLE_PATH=${4:-'/home/dan/data/projects/java/rumble'}
RUMBLE_JAR_NAME=${5:-'rumbledb-1.14.0-jar-with-dependencies.jar'}

REBUILD=${5:-"yes"}  # Set this to 'yes' if you want to rebuild the jar every time this script is executed

# Load common functions
. "$SCRIPT_PATH/ec2-helpers.sh"

# Create an experiment directory
EXPERIEMNT_NAME="RumbleDB_query_generation_run_$(date +%F_%H_%M_%S_%3N)"
experiments_dir="experiments/${EXPERIEMNT_NAME}"
mkdir -p ${experiments_dir}

# Build RumbleDB locally then send it to the AWS instance
if [ "${REBUILD}" == "yes" ]; then
  cd ${RUMBLE_PATH} && mvn clean compile assembly:single && cp ${RUMBLE_PATH}/target/${RUMBLE_JAR_NAME} ${SCRIPT_PATH}/${experiments_dir} && cd ${SCRIPT_PATH}
else
  cp ${RUMBLE_PATH}/target/${RUMBLE_JAR_NAME} ${SCRIPT_PATH}/${experiments_dir} && cd ${SCRIPT_PATH}
fi

# Deploy the cluster
deploy_cluster "$experiments_dir" 1 $INSTANCE_TYPE

# Deploy software on machines
echo "Deploying software..."
for dnsname in ${dnsnames[*]}
do
  (
    (
      ssh -q ec2-user@$dnsname "sudo yum update -y && sudo yum install java-1.8.0-openjdk -y"
      ssh -q ec2-user@$dnsname "mkdir -p /data/queries/"
      scp -r "${QUERY_PATHS}" ec2-user@$dnsname:/data/queries
      scp -r "${QUERY_PATHS}/../common" ec2-user@$dnsname:/data/queries
      scp ${experiments_dir}/${RUMBLE_JAR_NAME} \
        ${SCRIPT_PATH}/../snowflake.properties \
        ${SCRIPT_PATH}/evaluate-snowflake-query-generation.sh \
        ec2-user@$dnsname:/data
    ) &>> "$deploy_dir/deploy_$dnsname.log"
    echo "Done deploying $dnsname."
  ) &
done
wait
echo "Done deploying machines."