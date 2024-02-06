-- This SQL script is used to upload the ADL data to into Snowflake
-- Somewhat based on: https://docs.snowflake.com/en/user-guide/script-data-load-transform-parquet.html
-- For creating a storage integration between Snowflake and S3 follow this guide: https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html
-- run this within `snowsql` using: `!source /path/to/upload.sql`
-- run this using `snowsql` using: `$ snowsql -c <connection_name> -f /path/to/upload.sql`
SET warehouse_name = 'TEST_WAREHOUSE';
SET database_name = 'TEST';
SET schema_name = 'ADL';
SET table_name = 'adl';

CREATE DATABASE IF NOT EXISTS identifier($database_name);
USE DATABASE identifier($database_name);

CREATE SCHEMA IF NOT EXISTS identifier($schema_name);
USE SCHEMA identifier($schema_name);

USE WAREHOUSE identifier($warehouse_name);

-- Step 1) Create temporary external stage
CREATE OR REPLACE TEMPORARY STAGE hep_data
storage_integration = adl_integration 
URL = <PATH>
FILE_FORMAT = (TYPE = 'PARQUET');

-- Step 2) Create a table and populate it with the staged data
CREATE OR REPLACE EXTERNAL TABLE identifier($table_name) (
  run NUMBER(38, 0) AS (value:run::NUMBER(38, 0)),
  luminosityBlock NUMBER(38, 0) AS (value:luminosityBlock::NUMBER(38, 0)),
  event NUMBER(38, 0) AS (value:event::NUMBER(38, 0)),
  HLT  VARIANT AS (value:HLT::VARIANT),
  PV  VARIANT AS (value:PV::VARIANT),
  MET VARIANT AS (value:MET::VARIANT),
  Muon VARIANT AS (value:Muon::VARIANT),
  Electron VARIANT AS (value:Electron::VARIANT),
  Tau VARIANT AS (value:Tau::VARIANT),
  Photon VARIANT AS (value:Photon::VARIANT),
  Jet VARIANT AS (value:Jet::VARIANT)
) 
WITH LOCATION = @hep_data
FILE_FORMAT = (TYPE = PARQUET)
PATTERN='.*parquet';
