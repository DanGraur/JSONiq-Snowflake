# JSONiq to Snowflake SQL via Snowpark 

This repository contains the queries, main experiment and plotting scripts for the paper `Addressing the Nested Data Processing Gap: JSONiq Queries on Snowflake through Snowpark`.

The `workloads` folder contains two subfolders, one for each benchmark `ssb` and `adl`. 

Each of these benchmark folders contains three directories:

* `data`: contains READMEs and scripts for staging the data. The `upload.sh` is chiefly the script taking care of staging. The `upload.sql` (and `schema_multiple_columns.sql` for `adl`) contain the DDL for the staged tables.
* `experiment-scripts`: contains the scripts to run the Snowflake experiments. 
* `queries`: contains the queries themselves. This folder contains `sql/implementations` and `jsoniq/implementations`:
  * If you explore these folders you will find the queries used for the study. In the particular case of `jsoniq` you will also find the automatically generated translations (named either `translation.sql` or `query.sql`). 