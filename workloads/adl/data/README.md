# Using the ADL data in Snowflake

## Initial Snowflake setup

You will need to use the Snowflake Web UI and input the commands:

```SQL
-- Create warehouses
CREATE WAREHOUSE XSMALL WITH WAREHOUSE_SIZE='XSMALL';
CREATE WAREHOUSE LARGE WITH WAREHOUSE_SIZE='LARGE';

-- A default warehouse will get created which we do not need
DROP WAREHOUSE IF EXISTS COMPUTE_WH;

-- Create a database where the different schemas ('SF1' and '1000 event') are stored
CREATE DATABASE ADL;
```

Then make sure to create two connections in your `~/.snowsql/config` of the type:

```
[connections.xsmall]

accountname = <your-account-id>.eu-central-1
username = <your-username>
password = <your-password>

dbname = ADL
schemaname = ADL_1000
warehousename = XSMALL

[connections.large]

accountname = <your-account-id>.eu-central-1
username = <your-username>
password = <your-password>

dbname = ADL
schemaname = ADL
warehousename = LARGE
```

Finally, make sure to create an integration between S3 and Snowflake for uploading and storing the data internally in Snowflake. Follow [this guide](https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html) for the integration. When creating the integration Snowflake-side storage integration make you can use the following SQL command:

```SQL
CREATE OR REPLACE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::168929489144:role/snowflake-role' -- or your equivalent AWS ROLE
  STORAGE_ALLOWED_LOCATIONS = ('s3://rumbledb-snowflake-adl/SF1/', 's3://hep-adl-ethz/hep-parquet/native/', 's3://rumbledb-snowflake-adl/ssb/sf1', 's3://rumbledb-snowflake-adl/ssb/sf10', 's3://rumbledb-snowflake-adl/ssb/sf100', 's3://rumbledb-snowflake-adl/ssb/sf1000');
```

## Internal Tables

In order to create an internal table:

1. Use the `upload.sh`, passing the right parameters in order to ensure the table gets uploaded to the right DB, schema, etc.
  * Use: `./upload.sh internal adl s3://hep-adl-ethz/hep-parquet/native/Run2012B_SingleMu-1000.parquet XSMALL adl_1000` to upload the 1000 row reference dataset
  * Use `./upload.sh internal adl s3://rumbledb-snowflake-adl/SF1/ XSMALL adl` to upload the base dataset 

## Functions for ADL Queries

Our hand-written ADL queries require a set of SQL functions to be stored ahead of time the Snowflake such that they work correctly. To make this happen, first make sure to have `snowsql` installed [using this guide](https://docs.snowflake.com/en/user-guide/snowsql-install-config#installing-snowsql-on-linux-using-the-installer. Then, run the following command:

```
snowsql -c xsmall -f ../queries/sql/implementations/common/functions.sql
```  

Alternatively you can copy paste the code of the `functions.sql` script into a Snowflake worksheet and execute it there.

## Generating Subsets of the Full Dataset

Make sure to inspect and use the `generate_different_size_tables.sh` script. This script automatically sets up subsets of the data in the range of {1000 * 2^0, ..., 1000 * 2^15} events. It also sets up the functions required to run the ADL queries in each schema. Make sure to update this path in the script.

## (Optional) External Tables

In order to create an external table:

1. Make sure the relevant data is uploaded in S3  
1. Follow [this guide](https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html) to set up AWS and Snowflake relationship
1. Run the `upload_external.sql` script. Make sure to use the right `storage_integration` that you just created.


