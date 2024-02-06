# SSB Data

## Setup

Make sure to use [this repo](https://github.com/electrum/ssb-dbgen) as it generates the right version of the data.

Also make sure to use the command `for i in $( ls *.tbl ); do sed -i 's/|$//' ${i}; done` in the folder where the `.tbl` files are generated. This command eliminates the `|` at the end of each row. 

## Staging

use the `upload.sh` script in order to stage the data to Snowflake.