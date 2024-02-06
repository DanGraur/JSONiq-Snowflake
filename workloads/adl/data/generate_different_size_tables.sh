#!/usr/bin/env bash

# Deployment parameters
warehouse_name=${1:-'xsmall'} # 'xsmall' or 'large'
base_schema_name=${2:-'adl'}
database_name=${3:-'adl'}
table_name=${4:-'adl'}

snowflake_connection=${5:-"xsmall"}

import_functions=${6:-"yes"}  # Set to 'yes' if you want the functions to be imported in the schema

scales=${7:-"small"} # Can be 'small', 'large' or 'both'

FUNCTIONS_SQL_SCRIPT_PATH="/home/dan/data/projects/java/rumbledb-snowflake/workloads/adl/queries/sql/implementations/common/functions.sql"

temp_table_name="tmp_table"

# Create the subsamples
if [ "${scales}" = 'small' ] || [ "${scales}" = 'both' ]; then
  for i in {1..3} {6..15}; do 
    row_count=$(( 2**$i*1000 ))
    schema_name=${base_schema_name}_${row_count}

  read -r -d '' query << EOM
USE WAREHOUSE ${warehouse_name};
USE DATABASE adl;
USE SCHEMA adl;

CREATE OR REPLACE TABLE ${temp_table_name} (
  run NUMBER(38, 0),
  luminosityBlock NUMBER(38, 0),
  event NUMBER(38, 0),
  HLT  VARIANT,
  PV  VARIANT,
  MET VARIANT,
  Muon VARIANT,
  Electron VARIANT,
  Tau VARIANT,
  Photon VARIANT,
  Jet VARIANT
) AS SELECT run, luminosityBlock, event, HLT, PV, MET, Muon, Electron, Tau, Photon, Jet
  FROM adl
  LIMIT ${row_count};

CREATE SCHEMA IF NOT EXISTS ${schema_name};
CREATE TABLE ${database_name}.${schema_name}.${table_name} CLONE adl.adl.${temp_table_name};
EOM

    snowsql -c "${snowflake_connection}" -q "${query}"

    # The HEP functions also need to be imported
    if [ "${import_functions}" == "yes" ]; then 
      snowsql -c "${snowflake_connection}" -d "${database_name}" -s ${schema_name} -f ${FUNCTIONS_SQL_SCRIPT_PATH}  
    fi
  done
fi

# Create the supersamples

if [ "${scales}" = 'large' ] || [ "${scales}" = 'both' ]; then
  warehouse_name="large"  # We have to switch to a bigger warehouse here, else it will take very long 
  for i in {1..6}; do 
    sf=$(( 2**$i ))
    schema_name=${base_schema_name}_sf${sf}

    pref_sf=$(( 2**($i - 1) ))
    prev_schema_name=${base_schema_name}_sf${pref_sf}
    if [ ${i} -eq 1 ]; then
      prev_schema_name="adl"        
    fi 

  read -r -d '' query << EOM
USE WAREHOUSE ${warehouse_name};
USE DATABASE adl;
USE SCHEMA ${prev_schema_name};

CREATE OR REPLACE TABLE ${temp_table_name} (
  run NUMBER(38, 0),
  luminosityBlock NUMBER(38, 0),
  event NUMBER(38, 0),
  HLT  VARIANT,
  PV  VARIANT,
  MET VARIANT,
  Muon VARIANT,
  Electron VARIANT,
  Tau VARIANT,
  Photon VARIANT,
  Jet VARIANT
) AS (
  (SELECT run, luminosityBlock, event, HLT, PV, MET, Muon, Electron, Tau, Photon, Jet FROM ${table_name}) 
  UNION ALL 
  (SELECT run, luminosityBlock, event, HLT, PV, MET, Muon, Electron, Tau, Photon, Jet FROM ${table_name})
);

CREATE SCHEMA IF NOT EXISTS ${schema_name};
CREATE TABLE ${database_name}.${schema_name}.${table_name} CLONE ${database_name}.${prev_schema_name}.${temp_table_name};
DROP TABLE ${database_name}.${prev_schema_name}.${temp_table_name};
EOM

    snowsql -c "${snowflake_connection}" -q "${query}"

    # The HEP functions also need to be imported
    if [ "${import_functions}" == "yes" ]; then 
      snowsql -c "${snowflake_connection}" -d "${database_name}" -s ${schema_name} -f ${FUNCTIONS_SQL_SCRIPT_PATH}  
    fi
  done
fi