-- Create warehouses
CREATE WAREHOUSE XSMALL WITH WAREHOUSE_SIZE='XSMALL';
CREATE WAREHOUSE LARGE WITH WAREHOUSE_SIZE='LARGE';

-- A default warehouse will get created which we do not need
DROP WAREHOUSE IF EXISTS COMPUTE_WH;

-- Create a database where the different schemas ('SF1' and '1000 event') are stored
CREATE DATABASE ADL;