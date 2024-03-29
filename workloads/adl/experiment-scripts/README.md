# Running experiments

## Contents

This folder contains a set of scripts for running experiments, collecting the numbers and then plotting the data:

* Running experiments (for these, please have a look at the scripts and modify the parameters such that they work for you):
  * `evaluate-snowflake-queries.sh`: Runs the SQL hand-written queries in Snowflake. The results are dumped to an experiment folder whose location is reported when the script finishes.
  * `evaluate-rumbledb-queries.sh`: Runs the JSONiq queries via RumbleDB and executes them in Snowflake. This script also captures the query generation time (i.e. converting the JSONiq to SQL via RumbleDB+Snowpark). The results are dumped to an experiment folder whose location is reported when the script finishes. 
  * `query-generation-aws/`: is a folder containing a set of scripts for running the query generation experiment on AWS resources:
    * Create a `config.sh` file based on `config.sh.template`. Create an SSH key that you use for AWS as well as a valid EC2 instance profile 
    * `deploy.sh`: deploys a single node where you can run your experiments
    * `run_experiments.sh`: should be used to run the actual experiment
    * `terminate.sh`: should be used after the experiment is done in order to terminate the AWS VM
  * `evaluate-sweep.sh`: Runs either the hand-written queries or the automatically generated queries in Snowflake at various data scales. This data is then use to plot the sweeps.
* Fetching the query runtime metrics:
  * `fetch-snowflake-metrics.sh`: Once the queries have finished executing, Snowflake will store the metrics (e.g. compilation time, execution time, bytes scanned, etc.) internally (this may take a few minutes until the metrics are commited). The script will read the initial experiment logs (produced by `evaluate-snowflake-queries.sh` and `evaluate-rumbledb-queries.sh`) to fetch the relevant query ids. These query ids are then used to retrieve the query metrics and update the initial experiment logs with all the metrics. The complete metrics will be stored to an experiment folder whose location is reported when the script finishes. Note that `query-generation-aws/run_experiments.sh` will automatically fetch the remote experiments and save them locally as a `.zip` archive
* Plotting the query runtime metrics:
  * `plot.py`: Is the script used to generate the plots for the paper. See its parameters for more information on how it's supposed to be used.
  * `plot-all.sh`: Uses `plot.py` to generate all the plots (excluding the `query generation time` and the `sweeps`; these need to be generated independently using the `plot.py` script).


## Workflow

You should follow the following workflow:

1. Run (1) the `evaluate-snowflake-queries.sh`, (2) the `evaluate-rumbledb-queries.sh`, and (3) the `query-generation-aws` scripts to get the initial experiment logs
1. Use the paths to the previous experiments and plug them into the `fetch-snowflake-metrics.sh` script to fetch the Snowflake metrics
1. Using the logs generated by `fetch-snowflake-metrics.sh` use either `plot.py` to generate individual plots or the `plot-all.sh` script to generate all the plots at once (note some plots such as the query generation time might only make sense when individually plotted) 
